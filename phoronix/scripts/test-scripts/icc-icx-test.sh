#!/bin/sh
# I used this script to compare differences between the older icc and the newer icx compilers.
# Interestingly, icc pulled way ahead in SciMark2.

benchmark=scimark2
test_results_name="icc icx test"
compiler_list=(
	"icx"
	"icc"
)

declare -A spack_dict
spack_dict["icx"]="intel-oneapi-compilers@2025.2.0"
spack_dict["icc"]="intel-oneapi-compilers-classic@2021.10.0"

user_home=$(getent passwd $SUDO_USER | cut -d: -f6)
source "$user_home/spack/share/spack/setup-env.sh"

for compiler in "${compiler_list[@]}"; do
	spack load "${spack_dict[$compiler]}"
	export CC="$compiler"
	export CFLAGS="-O3 -xHost"
	export TEST_RESULTS_IDENTIFIER="${spack_dict[$compiler]}"
	export TEST_RESULTS_NAME="$test_results_name"
	export PERFORMANCE_PER_SENSOR="cpu.power"
	phoronix-test-suite batch-benchmark $benchmark
	spack unload "${spack_dict[$compiler]}"
done
