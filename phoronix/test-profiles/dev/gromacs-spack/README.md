# GROMACS Spack Test Profile for Phoronix Test Suite
This test profile is a modified version of [pts/gromacs-1.10.0](https://openbenchmarking.org/innhold/9e6f475587a7af5fb4b3a87137372d50d779d24a).

Modifications:
- Most notably, the GROMACS test is built using [Spack](https://spack.io/)
- The test is restricted to four physical cores (to reduce load on my test machine to an acceptable level)
