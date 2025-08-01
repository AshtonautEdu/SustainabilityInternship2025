#!/bin/sh
# This script was made to test different compiler flags with GROMACS via CFLAGS environment variable.
# It did not work. Current working theory is CMake shenanigans.

benchmark=local/gromacs-test
test_results_name="GROMACS Test"
flag_list=(
	"-O0"
	"-O1"
	"-O2"
	"-O3"
)

for flag in "${flag_list[@]}"; do
	export CFLAGS="$flag"
        export TEST_RESULTS_IDENTIFIER="$flag" 
	export TEST_RESULTS_NAME="$test_results_name" 
	phoronix-test-suite batch-benchmark $benchmark
done
