#/bin/sh
# Archlinux
# July 25, 2022

[ $_ = $0 ] || sourced=0

set -e
source shared/shared.sh
source /etc/os-release

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

    echo "/ 192.168.56.1(rw,no_subtree_check,insecure,all_squash,anonuid=0,anongid=0)" >> /etc/exports
    exportfs -rav

    systemctl enable nfs-server.service

    >&2 echo "INFO: You need to reboot in order to enable NFS."
}

if [ -z "$sourced" ]
then
    setup_packages
    setup_files
    setup_git
    setup_shell
    setup_ssh
    setup_timezone
    setup_nfs
    setup_cleanup
fi 
