#!/bin/sh
# This script was used to combine previous compiler flag testing with more recently discovered performance per watt utility.
# Performance and performance per watt results are closely related in this test.

benchmark=scimark2
flag_list=(
	"-O0"
	"-O1"
	"-O2"
	"-O3"
)
test_results_name="Compiler Flag Test - ${benchmark}"

for flag in "${flag_list[@]}"; do
	export CFLAGS="$flag"
	export TEST_RESULTS_IDENTIFIER="$flag"
	export TEST_RESULTS_NAME="$test_results_name"
	export PERFORMANCE_PER_SENSOR="cpu.power"
	phoronix-test-suite batch-benchmark $benchmark
done
