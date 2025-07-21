#!/bin/bash
# I used this script to observe differences between idle and load power usage as seen through RAPL
# The data returned was in line with expected behaviour, helping to confirm that my script works as intended.
# I was able to further corroborate this with Turbostat

energy_file="/sys/class/powercap/intel-rapl:0/energy_uj"

funcs=(sleep_func stress_func)
sleep_func() {
	sleep 30s
}
stress_func() {
	stress-ng --matrix 0 --timeout 30s
}

for func in "${funcs[@]}"; do
	echo "Running $func..."
	start_energy=$(cat "$energy_file")
	start_time=$(date +%s.%N)
	$func
	end_energy=$(cat "$energy_file")
	end_time=$(date +%s.%N)
	energy=$(echo "scale=6; ($end_energy - $start_energy) / 1000000" | bc)
	time=$(echo "$end_time - $start_time" | bc)
	power=$(echo "scale=3; ($energy / $time)" | bc)
	echo "Energy used: $energy J"
	echo "Time elapsed: $time s"
	echo "Average power consumption: $power W"
done
