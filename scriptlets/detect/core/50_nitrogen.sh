#!/bin/bash

# Copyright (C) 2018-2019 IoT.bzh
# Authors:
#    Valentin Lefebvre <valentin.lefebvre@iot.bzh>
# Released under the Apache 2.0 license

detect_nitrogen() {
	local -A keys
	[[ ! "$(cat /sys/firmware/devicetree/base/model)" =~ "Nitrogen" ]] && return 0;
	info "Nitrogen family detected."

	# soc information
	keys[soc_vendor]="Nitrogen"
	keys[soc_family]="$(readkey /sys/devices/soc0/family )"
	keys[soc_id]="$(readkey /sys/devices/soc0/soc_id)"
	keys[soc_name]="$(readkey /sys/devices/soc0/machine)"
	keys[cpu_cache_kb]="unknown"
	keys[gpu_name]=$(readkey /sys/firmware/devicetree/base/soc/gpu/compatible | cut -f 2- -d',')
	keys[soc_revision]="$(readkey /sys/devices/soc0/revision)"

	# detect cpu
	keys[cpu_freq_mhz]=$(readkey /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq)
	if [ ${keys[cpu_freq_mhz]} != "unknown" ]
	then keys[cpu_freq_mhz]=$((${keys[cpu_freq_mhz]}/1000))
	fi

	local k1=$(grep OF_COMPATIBLE_0 /sys/devices/system/cpu/cpu0/uevent | cut -f2 -d',')
	keys[cpu_compatibility]="$k1"

	# detect board
	keys[board_model]=$(readkey /sys/firmware/devicetree/base/compatible | cut -f2 -d',')
	# models=( $(tr '\0' '\n' </sys/firmware/devicetree/base/compatible | while IFS=',' read vendor model; do echo $model; done) )
	# keys[board_model]=$(IFS=- ; echo "${models[*]}")
	
	for x in ${!keys[@]}; do
		addkey $x "${keys[$x]}"
	done
}

detect_nitrogen