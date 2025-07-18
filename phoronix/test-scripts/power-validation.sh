#!/bin/bash

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
	energy=$(echo "($end_energy - $start_energy) / 1000000" | bc)
	echo "Energy used: $energy J"
done
