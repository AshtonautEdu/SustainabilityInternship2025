#!/bin/sh

CFLAGS="-O0" TEST_RESULTS_IDENTIFIER="-O0" TEST_RESULTS_NAME="Basic Flag Test" phoronix-test-suite benchmark scimark2
CFLAGS="-O1" TEST_RESULTS_IDENTIFIER="-O1" TEST_RESULTS_NAME="Basic Flag Test" phoronix-test-suite benchmark scimark2
CFLAGS="-O2" TEST_RESULTS_IDENTIFIER="-O2" TEST_RESULTS_NAME="Basic Flag Test" phoronix-test-suite benchmark scimark2
CFLAGS="-O3" TEST_RESULTS_IDENTIFIER="-O3" TEST_RESULTS_NAME="Basic Flag Test" phoronix-test-suite benchmark scimark2
