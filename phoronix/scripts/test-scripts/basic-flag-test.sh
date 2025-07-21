#!/bin/sh

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
