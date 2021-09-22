#!/bin/bash

# Copyright (C) 2018-2019 IoT.bzh
# Authors:
#    Stephane Desneux <stephane.desneux@iot.bzh>
#    Ronan Le Martret <ronan.lemartret@iot.bzh>
#    Valentin Lefebvre <valentin.lefebvre@iot.bzh>
# Released under the Apache 2.0 license

detect_os_release() {
    [[ ! -f /etc/os-release ]] && { error "Unable to open /etc/os-release"; return 1;}

    distro=$(cat /etc/os-release | grep -e "^NAME=")
    distro=${distro#*=}
    addkey os_name ${distro//\"/}
    version=$(cat /etc/os-release | grep -e "^VERSION=")
    version=${version#*=}
    addkey os_version ${version//\"/}
}

detect_os_release