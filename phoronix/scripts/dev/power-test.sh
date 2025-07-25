#!/bin/bash
# This script was made to see if I could use RAPL for power data gathering
# It works, but is superfluous since PTS has its own utility for the same purpose.
# Regardless, knowledge gained!

energy_file="/sys/class/powercap/intel-rapl:0/energy_uj"

for ((freq=4800; freq>=800; freq-=2000)); do
	echo "Running at ${freq}Mhz"
	cpupower frequency-set --max ${freq}MHz
	
	start_energy=$(cat "$energy_file")
	start_time=$(date +%s.%N)
	
	sudo -u $SUDO_USER phoronix-test-suite benchmark scimark2

	end_energy=$(cat "$energy_file")
	end_time=$(date +%s.%N)
	energy=$(echo "scale=6; ($end_energy - $start_energy) / 1000000" | bc)
	time=$(echo "$end_time - $start_time" | bc)
	power=$(echo "scale=3; ($energy / $time)" | bc)
	echo "Energy used: $energy J"
	echo "Time elapsed: $time s"
	echo "Average power consumption: $power W"
done
