#!/bin/bash

# Copyright (C) 2018-2019 IoT.bzh
# Authors:
#    Stephane Desneux <stephane.desneux@iot.bzh>
#    Ronan Le Martret <ronan.lemartret@iot.bzh>
#    Valentin Lefebvre <valentin.lefebvre@iot.bzh>
# Released under the Apache 2.0 license

detect_os_release() {
    [[ ! -f /etc/os-release ]] && { error "Unable to open /etc/os-release"; return 1;}

    lines=(`cat /etc/os-release | cut -d'=' -f2`)
    addkey os_name "${lines[0]}"
    version=$(echo ${lines[1]} | sed 's/"//')
    addkey os_version "${version}"
}

detect_afm_applications() {
    local packages=()
    [[ ! -d /var/local/lib/afm/applications ]] && { error "Unable to find /var/local/lib/afm/applications/"; return 1;}
    for package in $(ls /var/local/lib/afm/applications/); do
        packages+=($package)
    done

    addkey packages_afm_installed "${packages[@]}"
}

detect_os_release
detect_afm_applications