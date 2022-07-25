#/bin/sh
# Redhat
# July 25, 2022

[ $_ = $0 ] || sourced=0

set -e
source shared/shared.sh

# Detect CentOS version
OS_MAJOR=$(grep -oE '[0-9]+' /etc/centos-release | head -n1)

if [ -z "$OS_MAJOR" ]
then
    >&2 echo "ERROR: cannot parse /etc/centos-release (OS_MAJOR)"
    exit 1
fi

yum-install() {
    yum install -y $@
}

setup_packages() {
    if [ $OS_MAJOR -ge 8 ]
    then
        yum config-manager --set-enabled powertools
    fi

    # Wazuh required packages
    yum-install make gcc git automake autoconf libtool checkpolicy libcmocka-devel gcc-c++ libstdc++-static

    # Shell tools
    yum-install gdb nano valgrind net-tools psmisc tcpdump git wget strace python3

    if [ $OS_MAJOR -ge 7 ]
    then
        yum-install policycoreutils
    else
        yum-install policycoreutils-python
    fi

    # CMake >= 3.20
    if [ $OS_MAJOR -ge 8 ]
    then
        yum-install cmake
    else
        wget -qO cmake.sh https://github.com/Kitware/CMake/releases/download/v3.22.3/cmake-3.22.3-linux-x86_64.sh
        sh cmake.sh --skip-license --prefix=/usr/local
        rm cmake.sh
    fi
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
