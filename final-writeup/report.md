# Toward Sustainable Computing: Designing Efficiency Benchmarks (44-COMP)

## Introduction

Growth in areas such as artificial intelligence, machine learning, and data-intensive scientific research have produced an increase in the demands placed upon high performance computing (HPC) [^1]. This trend can be seen in the University of Leeds' own HPC system, Aire [^2], which continues to see growth in both resource utilisation and active user count [^3]. This growth generates an increase in power consumption necessary for computation, with significant implications for both environmental impact and operational expenses [^a]. This project aims to investigate methods of benchmarking a variety of computing setups, with a particular focus on measuring performance per watt, with the end goal of supporting decisions on energy-efficient HPC practices.

## Key Tools

#### Phoronix Test Suite

The Phoronix Test Suite (PTS) [^4] was used to execute benchmarks as well as generate graphs from the produced data. Tests in PTS are defined with "test profiles", collections of files that specify how specific programs (GROMACS [^5], for example) should be built and executed as well as how results are processed. Test profiles act as an abstraction layer, exposing configuration options to end users while hiding details of implementation, meaning that developers can encode tests for reproducibility while end users can easily make use of them.

#### Spack

Spack [^6] is a package manager designed for HPC environments, where users of a single HPC system may simultaneously require different versions and configurations of the same package. Spack allows for detailed customisation of packages as well as their dependencies, which can then coexist with other builds of the same package on a single system. Package configuration options are defined by "recipes", which define how packages are sourced and built; these recipes help ensure building Spack packages is consistent and reproducible. In addition, Spack allows for all of this to be done without administrative privileges.

#### Combined Usage

PTS has many strengths in data gathering and visualisation, being able to easily gather data from sensors (power consumption data, most notably), and produce reports and graphs in various file formats. However, some weaknesses in test building and execution became apparent during the project, especially in the context of HPC. It was found that administrative privileges were sometimes required for installing tests with certain dependencies, which interfered with the use of PTS on Aire. Furthermore, no obvious method could be found to influence the configuration of dependencies (such as version), giving some cause for concern regarding reproducibility of results if different dependencies were used in the future.

These issues were addressed by creating custom PTS test profiles that made use of Spack to build test software, allowing the software and its dependencies to be customised as desired and ensuring the test could be installed without administrative privileges. As a proof of concept, a custom GROMACS test profile using Spack was created, and the process of doing so was documented in detail as a reference point for future Spack integration [^7].  Spack was also used to provide the PHP dependencies required by PTS.

## Preliminary Findings

Some preliminary findings were gained while testing benchmarking methods during the project. Unless otherwise indicated, the following results were obtained using a local workstation with an Intel I7-10700 CPU [^b].

One avenue of investigation was the impacts of compilers on the raw performance and energy efficiency of compiled programs. Intel, for example, offers a deprecated "classic" set of its oneAPI compilers alongside the set of compilers it currently supports [^8]. Without further exploration, it might be considered reasonable to assume that the more modern compilers (that Intel themselves encourage the use of [^9]) would be more performant, if not more energy-efficient. However, preliminary testing suggests that this is not always the case.

![](/results/intel-oneapi-comparison/1-1.png)
![](/results/intel-oneapi-comparison/1-2.png)
[^c]
*A comparison of Intel compilers using the SciMark 2.0 PTS test profile [^10]. For both compilers, the compiler flags used were  `-O3 -march=native -axCORE-AVX2` .*

The above graphs show the difference in raw performance and performance per watt when the SciMark 2.0 benchmark software is compiled using the different Intel oneAPI compilers. SciMark 2.0 was primarily chosen for its low runtime, allowing for faster verification of functioning workflows, but the software also aims to benchmark computations that can be found in scientific and engineering applications [^11]. The data suggests that, perhaps contrary to expectations, SciMark 2.0 is more efficient in both measured metrics when compiled using the classic compiler set as opposed to the newer compiler set.

The impacts on raw performance and energy efficiency produced by setting upper limits on CPU frequency was also investigated. 

![](/results/scimark-cpu-freqs.png)
*A comparison of different upper limits set on CPU frequency using the SciMark 2.0 PTS test profile.*

As can be observed from the graph, the tests suggest a non-linear relationship between the upper limit set on CPU frequency and the performance per watt of a program, with peak energy efficiency being achieved somewhere between minimum and maximum CPU frequency. [^d]. 

## Next Steps

This project has laid the foundations of further exploration surrounding energy efficiency in computation, particularly in the context of HPC. To allow for the project's efforts to be reproduced and built upon, produced work has been collected under a GitHub repository [^12][^e]. Specific efforts to package PTS and Spack together alongside related scripts have prompted the creation of a second repository, "PTS-Pack" [^13]. Currently, PTS-Pack is able to setup PTS and Spack via the execution of a single script, and it has been tested to be functional on Aire. One area of future development could be to nurture PTS-Pack into a collection of Spack-integrated PTS test profiles that could be run on HPC environments in general and on Aire specifically.

Preliminary testing, as outlined previously, has indicated some areas that further testing could explore to generate conclusive results supported by rigorous statistical analysis. It would be ideal to ensure that such testing involves benchmarks that mirror the most common workloads encountered in HPC environments. 

So far, all testing has been conducted using a local workstation with administrative privileges. Such privileges are necessary for the current methodology for power consumption monitoring, which makes use of Running Average Power Limit (RAPL) interfaces [^14] and PTS' functionality (which possibly uses the same mechanism underneath). Similarly, administrative privileges are needed to enforce upper limits on CPU frequency with cpupower. Therefore, further work is needed to explore alternatives for use on HPC systems. On Aire, possible solutions may be available through Slurm [^15], Aire's job scheduler.

An increase in the emphasis placed on energy efficiency, and providing end users of HPC systems with relevant tools and information, could even form part of a wider-scale shift towards energy usage as a key variable to be considered in HPC resource allocation.

It can be seen that while much has been done to kickstart the process, there is still plenty left to explore and develop.

[^1]: https://arxiv.org/pdf/2506.19019
[^2]: https://arc.leeds.ac.uk/platforms/aire/
[^3]: https://arc.leeds.ac.uk/ready-set-compute-aire-at-work/
[^4]: https://www.phoronix-test-suite.com/
[^5]: https://www.gromacs.org/
[^6]: https://spack.io/
[^7]: https://github.com/AshtonautEdu/SustainabilityInternship2025/blob/main/phoronix/test-profiles/spack-integration.md
[^8]: https://www.intel.com/content/www/us/en/developer/tools/oneapi/dpc-compiler.html
[^9]: https://www.intel.com/content/www/us/en/developer/articles/release-notes/oneapi-c-compiler-release-notes.html
[^10]: https://openbenchmarking.org/test/pts/scimark2
[^11]: https://math.nist.gov/scimark2/about.html
[^12]: https://github.com/AshtonautEdu/SustainabilityInternship2025/tree/main
[^13]: https://github.com/AshtonautEdu/pts-pack/tree/main
[^14]: https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/running-average-power-limit-energy-reporting.html
[^15]: https://slurm.schedmd.com/overview.html

[^a]: Some numbers for Aire's power consumption could be interesting, if possible
[^b]: Double-check specifications (or maybe just re-run tests on my own machine?)
[^c]: Fix text (probably just remove :) )
[^d]: Similar tests with GROMACS suggested that peak energy efficiency is achieved at different frequencies for different programs/workloads, but I don't have the relevant data right now >:( . It would be really nice to have this, as it warns against assuming identical behaviours for each program, but GROMACS also takes quite a while to run compared to SciMark!
[^e]: Do I need to set some kind of licence for this?
