#!/bin/sh
# This file was used to try out the Phoronix Test Suite with different compiler flags.
# It worked for SciMark2, which will happily be modified by the CFLAGS environment variable.
# It did not work for GROMACS.

benchmark=scimark2
flag_list=(
	"-O0"
	"-O1"
	"-O2"
	"-O3"
)
test_results_name="Basic Flag Test"

for flag in "${flag_list[@]}"; do
	CFLAGS="$flag" TEST_RESULTS_IDENTIFIER="$flag" TEST_RESULTS_NAME="$test_results_name" phoronix-test-suite benchmark $benchmark
done
