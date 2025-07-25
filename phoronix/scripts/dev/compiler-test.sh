#!/bin/sh
# This script was made to test using Spack to swap between compilers, enabling comparisons between them.
# It works, and differences can be seen even with the below parameters.
# However, the test is rebuilt each time compiler parameters are changed. Not a problem for SciMark2, which is small,
# but likely to be a big time sink later if not sorted. I think custom test profiles will allow for built
# tests to be reused.

benchmark=scimark2
test_results_name="Compiler Test - ${benchmark}"
compiler_list=(
	"gcc"
	"clang"
	"icx"
	"aocc"
)

declare -A spack_dict
spack_dict["gcc"]="gcc@15.1.0"
spack_dict["llvm@20.1.6"]="llvm@20.1.6"
spack_dict["icx"]="intel-oneapi-compilers@2025.2.0"
spack_dict["aocc"]="aocc@5.0.0"

declare -A cflag_dict
cflag_dict["gcc"]="-O3 -march=native"
cflag_dict["clang"]="-O3 -march=native"
cflag_dict["icx"]="-O3 -xHost"
cflag_dict["aocc"]="-O3 -march=native"

user_home=$(getent passwd $SUDO_USER | cut -d: -f6)
source "$user_home/spack/share/spack/setup-env.sh"

for compiler in "${compiler_list[@]}"; do
	spack load "${spack_dict[$compiler]}"
	export CC="$compiler"
	export CFLAGS="${cflag_dict[$compiler]}"
	export TEST_RESULTS_IDENTIFIER="${compiler} (${CFLAGS})"
	export TEST_RESULTS_NAME="$test_results_name"
	export PERFORMANCE_PER_SENSOR="cpu.power"
	phoronix-test-suite batch-benchmark $benchmark
	spack unload "${spack_dict[$compiler]}"
done
