#/bin/sh
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
    pacman-install nano gdb valgrind git tcpdump wget net-tools

    >&2 echo TODO: setup_packages
    return

    # Wazuh required packages
    yum-install checkpolicy nodejs npm libcmocka-devel
}

setup_python() {
    # This is like yum-builddep python3.
    pacman-install gcc git make automake autoconf libtool libnghttp2 libpsl librtmp0 brotli python perl-text-glob expat bzip2 gdbm openssl libffi zlib libnsl tk sqlite valgrind bluez-libs mpdecimal llvm gdb xorg-server-xvfb

    pacman-install python-pip
    pip3 install jq pytest numpydoc psutil pytest-html jsonschema paramiko
}

setup_nfs() {
    pacman-install nfs-utils

    echo "/ 192.168.33.1(rw,no_subtree_check,insecure,all_squash,anonuid=0,anongid=0)" >> /etc/exports
    exportfs -rav

    systemctl enable nfs-server.service
    systemctl start nfs-server.service
}

setup_packages
setup_python
setup_files
setup_git
setup_shell
setup_ssh
setup_timezone
setup_nfs
setup_cleanup
