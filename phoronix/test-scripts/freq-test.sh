#!/bin/bash

benchmark=local/gromacs-test
test_results_name="Frequency Test - ${benchmark}"
freq_step=100

for ((freq=4800; freq>=800; freq-=$freq_step)); do
	cpupower frequency-set --max ${freq}MHZ 
	export TEST_RESULTS_NAME="$test_results_name" 
	export TEST_RESULTS_IDENTIFIER="${freq} MHz" 
	sudo -u $SUDO_USER -E phoronix-test-suite batch-benchmark $benchmark
done
