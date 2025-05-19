#! /bin/bash
# Vikman Fernandez-Castro
# June 4, 2020

set -e
source shared/shared.sh

pacman-install() {
    pacman -Syu --noconfirm $@
}

setup_packages() {
    # Wazuh required packages
    pacman-install make gcc cmake automake autoconf libtool cmocka

    # Shell tools
    pacman-install nano gdb valgrind git tcpdump wget net-tools python
}

setup_nfs() {
    pacman-install nfs-utils

    echo "/ 192.168.33.1(rw,no_subtree_check,insecure,all_squash,anonuid=0,anongid=0)" > /etc/exports
    exportfs -rav

    systemctl enable nfs-server.service
    # systemctl start nfs-server.service
    >&2 echo "INFO: You need to reboot in order to enable NFS."
}

setup_packages
setup_files
setup_git
setup_shell
setup_ssh
setup_timezone
setup_nfs
setup_cleanup
