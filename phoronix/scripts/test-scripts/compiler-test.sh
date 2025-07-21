#!/bin/sh
# This script was made to test using Spack to swap between compilers, enabling comparisons between them.
# It works, and differences can be seen even with the below parameters.
# However, the test is rebuilt each time compiler parameters are changed. Not a problem for SciMark2, which is small,
# but likely to be a big time sink later if not sorted. I think custom test profiles will allow for built
# tests to be reused.

benchmark=scimark2
test_results_name="Compiler Test - ${benchmark}"
compiler_list=(
	"gcc@15.1.0"
	"llvm@20.1.6"
)
declare -A cc_dict
cc_dict["gcc@15.1.0"]="gcc"
cc_dict["llvm@20.1.6"]="clang"

user_home=$(getent passwd $SUDO_USER | cut -d: -f6)
source "$user_home/spack/share/spack/setup-env.sh"

for compiler in "${compiler_list[@]}"; do
	spack load "$compiler"
	export CC="${cc_dict[$compiler]}"
	echo $CC
	export TEST_RESULTS_IDENTIFIER="$compiler"
	export TEST_RESULTS_NAME="$test_results_name"
	export PERFORMANCE_PER_SENSOR="cpu.power"
	phoronix-test-suite batch-benchmark $benchmark
	spack unload "$compiler"
done
