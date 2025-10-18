#!/usr/bin/env bash

SEPARATOR="   "

get_memory() { free | awk '/Mem:/ {printf("%.0f\n", ($3/$2) * 100)}'
}

get_cpu() {
	read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
	total=$((user + nice + system + idle + iowait + irq + softirq + steal))
	usage=$((100 * (total - (idle + iowait)) / total))
	echo "$usage"
}

get_time() {
	date +"%H:%M > %d/%m/%Y"
}

get_battery() {
	cat /sys/class/power_supply/BAT0/capacity
}

while true; do
	STATUS_MSG=""
	STATUS_MSG+="${SEPARATOR}BAT:$(get_battery)%"
	STATUS_MSG+="${SEPARATOR}RAM:$(get_memory)%"
	STATUS_MSG+="${SEPARATOR}CPU:$(get_cpu)%"
	STATUS_MSG+="${SEPARATOR}$(get_time)"
	echo "${STATUS_MSG}"
	sleep 1
done
