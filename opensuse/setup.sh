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
    [ "$(hostname)" == "tumbleweed" ] && setup_tumbleweed 

    zypper -n install nano
    zypper -n install curl
    zypper -n install wget
    zypper -n install git
    zypper -n install net-tools
    #zypper -n install gnupg2    
}

if [ -z "$sourced" ]
then
    setup_packages
    setup_shared
fi
