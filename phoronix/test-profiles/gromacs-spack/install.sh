#!/bin/sh
if [ -z "$SPACK_PATH" ]; then
	wget https://github.com/spack/spack/archive/develop.tar.gz
	tar -xf develop.tar.gz
	mv spack-develop spack
	export SPACK_PATH=${HOME}/spack
fi
source ${SPACK_PATH}/share/spack/setup-env.sh
spack install gromacs
tar -xf water_GMX50_bare.tar.gz
echo "#!/bin/sh
source ${SPACK_PATH}/share/spack/setup-env.sh
spack load gromacs
mpirun --allow-run-as-root -np 4 gmx_mpi grompp -f pme.mdp  -o bench.tpr
mpirun --allow-run-as-root -np 4 gmx_mpi mdrun -resethway -npme 0 -notunepme -noconfout -nsteps 1000 -v -s  bench.tpr
" >  run-gromacs
chmod +x run-gromacs
echo "#!/bin/sh
unset OMP_NUM_THREADS
cd \$2
rm -f *bench.tpr*
\$HOME/run-gromacs > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > gromacs-spack
chmod +x gromacs-spack
