#!/bin/sh
#
# usage: gromacs-profile-editor source_path test_name flags
#
# This script modifies a default PTS GROMACS 1.10.0 test profile by:
# - Renaming it
# - Using custom compiler flags
# - Forcing a maximum of 4 cores to be used
# - Disabling GROMACS backup files



src=$1
test_name=$2
cxxflags=$3
cflags=$3 # possibly not used, but better safe than sorry

# Rename test profile directory and set as current directory
cd ${src}/..
mv $src ./${test_name}
cd ${test_name}

# Insert flags (only way I could find to force cmake to use custom flags ONLY)
sed -i "6s|$| -DCMAKE_CXX_FLAGS_RELEASE=\"${cxxflags}\"|" ./install.sh
sed -i "6s|$| -DCMAKE_C_FLAGS_RELEASE=\"${cflags}\"|" ./install.sh

# Force 4 cores (keeps the test machine happy)
sed -i "9a export NUM_CPU_PHYSICAL_CORES=4" ./install.sh

# Disable backup files (was causing issues with high run counts)
sed -i "10a export GMX_MAXBACKUP=\"-1\"" ./install.sh

# Rename test init script (PTS will complain otherwise)
sed -i "44,45s|gromacs|${test_name}|" ./install.sh
