#/bin/sh
# OpenSuse
# July 25, 2022

[ $_ = $0 ] || sourced=0

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

    if [ "$(hostname)" == "tumbleweed" ]
    then
        setup_tumbleweed
    fi    
}

setup_nfs() {
    >&2 echo TODO: setup_nfs
    return
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
