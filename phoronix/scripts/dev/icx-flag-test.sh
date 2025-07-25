#!/bin/sh
# I used this script to verify that different flags were having an effect on the icx compiler.
# Both -native=march and -xHost made an improvement, with xHost possibly performing best.

benchmark=scimark2
flag_list=(
	"-O3"
	"-O3 -march=native"
	"-O3 -xHost"
)
test_results_name="icx flag test"

user_home=$(getent passwd $SUDO_USER | cut -d: -f6)
source "$user_home/spack/share/spack/setup-env.sh"
spack load intel-oneapi-compilers@2025.2.0
export CC="icx"
for flag in "${flag_list[@]}"; do
	CFLAGS="$flag" TEST_RESULTS_IDENTIFIER="$flag" TEST_RESULTS_NAME="$test_results_name" phoronix-test-suite benchmark $benchmark
done
spack unload intel-oneapi-compilers
