#!/bin/sh
#
# This script runs custom GROMACS tests (as defined in ./gromacs-profile-editor.sh)
# with different compiler optimisation flags for each run.
# Unlike previous attempts to change the compiler flags for GROMACS,
# these scripts have been verified to work.

ptspath="/var/lib/phoronix-test-suite/test-profiles/"

for i in $(seq 3 -1 0); do
	export TEST_RESULTS_IDENTIFIER="-O${i}"
	export TEST_RESULTS_NAME="GROMACS flags test"
	export PERFORMANCE_PER_SENSOR="cpu.power"

	cp -r "${ptspath}/pts/gromacs-1.10.0" "${ptspath}/local"
	./gromacs-profile-editor.sh "${ptspath}/local/gromacs-1.10.0" "gromacs-autotest" "-O${i} -march=native"

	phoronix-test-suite batch-benchmark local/gromacs-autotest

	rm -rf "${ptspath}/local/gromacs-autotest"
done
