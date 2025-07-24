#!/bin/sh

# This script creates several SciMark2 test installations with different compiler flags,
# then runs them from the same entry point. Said entry point is a symlink that the script
# points to different installations as needed. 
#
# By doing so, PTS thinks its running the same test each time 
# (and therefore combines results into a single graph), while the reality is
# that (slightly) different tests are being run each time. Using different
# installations means that tests don't need rebuilding every time a change is made.

flags=(
	"-O0"
	"-O1"
	"-O2"
	"-O3"
)
test_profile_path="/var/lib/phoronix-test-suite/test-profiles"
installed_test_path="/var/lib/phoronix-test-suite/installed-tests/local"

# Install if scimark-multi isn't present
# (There's probably more needed for rigour here, but it's enough to showcase the process)
if [ ! -d "${test_profile_path}/local/scimark-multi" ]; then
	
	# Make a local copy of PTS' SciMark2 v1.3.2 test profile
	cp -r "${test_profile_path}/pts/scimark2-1.3.2" "${test_profile_path}/local/scimark-multi"

	# Rename PTS entry point (PTS complains otherwise)
	sed -i "11,12s|\(.*\)scimark2|\1scimark-multi|" "${test_profile_path}/local/scimark-multi/install.sh"
	
	# Make unique installations for each flag arg
	for i in ${!flags[@]}; do
		export CFLAGS=${flags[$i]}
		phoronix-test-suite install-test local/scimark-multi
		mv "${installed_test_path}/scimark-multi" "${installed_test_path}/scimark-multi-${i}"
	done
fi

# Running phase
for i in ${!flags[@]}; do
	export TEST_RESULTS_IDENTIFIER=${flags[$i]}
	export TEST_RESULTS_NAME="SciMark Multi"
	export PERFORMANCE_PER_SENSOR="cpu.power"
	
	# This feels like such a hack of a solution, but as far as I can see, 
	# it's either fool PTS into thinking it's running the same test profile each time
	# or faff around with editing the graph data file afterwards.
	# Funnily enough, I went for the option that was essentially a single-line solution!
	ln -snf "${installed_test_path}/scimark-multi-${i}" "${installed_test_path}/scimark-multi"
 
	phoronix-test-suite batch-run local/scimark-multi
done
