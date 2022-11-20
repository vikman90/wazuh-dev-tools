#! /bin/bash
# Vikman Fernandez-Castro
# February 25, 2022

set -e
source shared/shared.sh

setup_tumbleweed() {
    rm /etc/zypp/repos.d/*.repo
    zypper ar -f -c http://download.opensuse.org/tumbleweed/repo/oss repo-oss
    zypper ar -f -c http://download.opensuse.org/tumbleweed/repo/non-oss repo-non-oss
    zypper ar -f -c http://download.opensuse.org/tumbleweed/repo/debug repo-debug
    zypper ar -f -c http://download.opensuse.org/update/tumbleweed/ repo-update
    zypper cc -a
    zypper ref
    zypper -n dup --allow-vendor-change
}

setup_packages() {
    # Wazuh required packages
    zypper -n install make gcc gcc-c++ automake libtool cmake curl openssl hostname

    # Shell tools
    zypper -n install wget gdb nano git tcpdump strace valgrind psmisc
}

setup_nfs() {
    zypper -n in nfs-kernel-server
    systemctl enable nfs-server
    # systemctl restart nfs-server

    # firewall-cmd --add-service=nfs --permanent
    # firewall-cmd --reload

    echo "/ 192.168.33.1(rw,no_subtree_check,insecure,all_squash,anonuid=0,anongid=0)" > /etc/exports
    exportfs -ra
}

if [ "$(hostname)" = "tumbleweed" ]
then
    setup_tumbleweed
fi

setup_packages
setup_files
setup_git
setup_shell
setup_ssh
setup_timezone
setup_nfs
setup_cleanup
