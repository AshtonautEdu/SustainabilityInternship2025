# Spack Integration Into A Phoronix Test Suite (PTS) Test Profile
This is a write-up regarding my experiences creating a custom [PTS](https://www.phoronix-test-suite.com/) test profile that uses [Spack](https://spack.io/) for the entire build process. Skip to "[Process](#process)" if you want to jump straight into the technical details.

## Motivations
Why do this? Because I thought it would be interesting! While very true, I appreciate that the satisfaction of my interest may be of no satisfaction to others, for which I offer the following:
- A standardised method for test build configuration
  -  In my experience, different methods may be necessary to specify compiler options depending on the test profile in question. [SciMark](https://openbenchmarking.org/test/pts/scimark2), for example, was very happy to obey environment variables such as CC and CFLAGS, and I believe this method is encouraged (if not expected) by Phoronix. However, [GROMACS](https://openbenchmarking.org/test/pts/gromacs-1.10.0) required modification of the test profile itself in order to achieve the same results. Who knows what it might take to modify a given test profile? I certainly don't! However, by using Spack to install test software, a standardised method is reached, which is that provided by Spack. This also brings the benefits of much greater and granular control over the configuration of the test software itself as well as all of its dependencies, which leads to...
- Greater control over dependencies
  - As far as I can tell, Phoronix manages test profile dependencies by simply requesting the latest version from an available package manager (YUM, say). This leaves no guarantee that a later install of the same test profile will actually result in the same test being installed, potentially skewing produced results. With the right configuration (which, admittedly, I still need to properly look into), Spack should allow such details to be locked in place, ensuring greater reproducibility in the future.
- Less concern about having to install dependencies
  - As noted previously, Phoronix uses an available package manager to install dependencies. The consequence? No root, no automatic dependency management. This is avoided and much simplified by using Spack.

## Process

PTS test profiles can have some variation between them, so there's not necessarily a uniform method of modifying a test profile to use Spack. To make matters worse, "documentation" and other info online can often be summarised as "go figure it out yourself". To exemplify the process, I'll detail my experiences of modifying the [pts/gromacs-1.10.0](https://openbenchmarking.org/innhold/9e6f475587a7af5fb4b3a87137372d50d779d24a) profile to produce "[gromacs-spack](https://github.com/AshtonautEdu/SustainabilityInternship2025/tree/main/phoronix/test-profiles/dev/gromacs-spack)"

Within the test profile, 4 files of importance can be found. Depending on your source, you may also see "`changelog.json`" and "`generated.json`" - these are not necessary for a functional test profile, and are therefore ignored. Instead, the following files are considered:

### test-definition.xml

As the name implies, much about the test itself is defined here. It may be desirable to change much of the metadata stored here: maintainer, title, description, etc., but none of this affects the functionality of the test itself. One detail that definitely needs attention, however, is any declared dependencies. In GROMACS' `test-definition.xml`, for example, the following line is found: `<ExternalDependencies>build-utilities, cmake, openmpi-development</ExternalDependencies>`. A reason for integrating Spack is to remove the need for such dependencies, so lines containing them should be deleted.

### downloads.xml

This file specifies details regarding files to be downloaded for the test. In the GROMACS example, two files can be seen: `gromacs-2025.0.tar.gz` and `water_GMX50_bare.tar.gz`. The first file is GROMACS itself; the plan is to use Spack to install this instead, so this file should be removed from the list. The following lines are deleted:
```xml
    <Package>
      <URL>http://ftp.gromacs.org/gromacs/gromacs-2025.0.tar.gz</URL>
      <MD5>4e9f043fea964cb2b4dd72d6f39ea006</MD5>
      <SHA256>a27ad35a646295bbec129abe684d9d03d1e2e0bd76b0d625e9055746aaefae82</SHA256>
      <FileName>gromacs-2025.0.tar.gz</FileName>
      <FileSize>44417653</FileSize>
    </Package>
```
The second file is a benchmarking workload used by GROMACS during the test. Spack won't give us this file, so it should definitely be left included! As might be imagined, other workloads to test could be defined here for download as well.

Spack itself is not declared for download here. This is because files declared in `downloads.xml` are always downloaded when a test profile is installed, but the desired behaviour is for Spack to only be downloaded when a path to an existing Spack installation is not provided. Instead, this conditional download is handled in `install.sh`.

### install.sh

This script is called after the files defined in `downloads.xml` are downloaded. Its purpose is to process the files (extraction, compilation, etc.) and produce scripts for execution when running a test. Once again consulting the GROMACS example, I made several edits.

The first step I took was to remove this rather unwieldy block of code:
```sh
cd ~
mkdir cuda-build
if ! which nvcc >/dev/null 2>&1 ;
then
        if [ -d /usr/local/cuda ]
        then
                export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:$LD_LIBRARY_PATH
                export PATH=/usr/local/cuda/bin/:$PATH
        fi
fi
if which nvcc >/dev/null 2>&1 ;
then
        cd cuda-build
        cmake ../gromacs-2025.0 -DGMX_MPI=OFF -DGMX_OPENMP=ON -DGMX_GPU=CUDA -DGMX_BUILD_OWN_FFTW=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON
        make -j $NUM_CPU_CORES

        echo "#!/bin/sh
        \$HOME/cuda-build/bin/gmx grompp -f pme.mdp 
        \$HOME/cuda-build/bin/gmx mdrun -resethway -noconfout -nsteps 4000 -v -pin on -nb gpu
        " >  run-gromacs
        chmod +x run-gromacs
        cd ~
fi
```
This deleted block concerns the ifs and hows of generating a CUDA build of GROMACS. If such a thing was desired (which it isn't on my test machine, which is lacking any discrete GPU at all), this would instead be handled by Spack.

Next, I removed lines related to the extraction and building of GROMACS, once again stressing that Spack is now responsible for this:
```sh
tar -xf gromacs-2025.0.tar.gz
```
```sh
mkdir mpi-build
cd mpi-build
cmake ../gromacs-2025.0 -DGMX_OPENMP=OFF -DGMX_MPI=ON -DGMX_GPU=OFF -DGMX_BUILD_OWN_FFTW=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON
make -j $NUM_CPU_CORES
echo $? > ~/install-exit-status
```

Building GROMACS is instead handled by inserting the following code right at the start of the script:
```sh
if [ -z "$SPACK_PATH" ]; then
        wget https://github.com/spack/spack/archive/develop.tar.gz
        tar -xf develop.tar.gz
        mv spack-develop spack
        export SPACK_PATH=${HOME}/spack
fi
source ${SPACK_PATH}/share/spack/setup-env.sh
spack install gromacs
```
This tells the script to look out for a `SPACK_PATH` environment variable, defined before installing the test through PTS, which is how the test profile is made aware of existing Spack installations. If none is found, the install script will automatically install Spack alongside the rest of the test files. In either event, the Spack setup script is sourced, and GROMACS is installed. 

All that remains is to modify the produced run scripts. I modified the produced `run-gromacs` script like so:
```sh
source ${SPACK_PATH}/share/spack/setup-env.sh
spack load gromacs
mpirun --allow-run-as-root -np 4 gmx_mpi grompp -f pme.mdp  -o bench.tpr
mpirun --allow-run-as-root -np 4 gmx_mpi mdrun -resethway -npme 0 -notunepme -noconfout -nsteps 1000 -v -s  bench.tpr
```
The first two lines are necessary to make GROMACS available on test runs. With GROMACS now being loaded through Spack, the call to `gmx_mpi` is modified in the following two lines to compensate. Furthermore, `-np`'s argument has been fixed to 4 (meaning that 4 processes will run). This is strictly for the benefit for my own test machine, which can be temperamental when stressed, and may be left unaltered if your own machine is more easily placated.

Finally, the produced `gromacs` script is altered like so:
```sh
\$HOME/run-gromacs > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > gromacs-spack
chmod +x gromacs-spack
```
The path for `run-gromacs` is amended in line with the other edits that have just been made. Finally, the name of the produced script is edited (to `gromacs-spack`) in this case. When running a PTS test (e.g. `phoronix-test-suite run local/testname`), PTS looks for a script `testname.sh` immediately inside of test profile directory `testname` to execute, so it's important to edit this script name appropriately. In this case, the name of the test is `gromacs-spack`, so the initial run script is renamed to match.

### results-definition.xml

This file specifies how results from the test appear in the log file so that PTS can fish them out. I've yet to find a need to edit this file, but it's certainly necessary to keep around. 

## Wrapping Up

After all necessary file edits are made, they're bundled together into a directory (`gromacs-spack` in the example). This directory is then placed in the user's local PTS test profiles directory (`~/.phoronix-test-suite/test-profiles/local` by default, or `/var/lib/phoronix-test-suite/installed-tests/local` for root).

If desired, set `SPACK_PATH` to the top-level directory of a Spack installation, then install the test through PTS (e.g. `phoronix-test-suite install local/testname`).
