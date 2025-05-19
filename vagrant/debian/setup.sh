#! /bin/bash
# Vikman Fernandez-Castro
# February 8, 2020

[ "$_" = "$0" ] || sourced=0

set -e
source shared/shared.sh
source /etc/os-release

setup_network() {
    # Ubuntu Kinetic has no default gateway, this prevents it from reaching the
    # Internet when defining an additional private network.

    if ! ip route | grep default > /dev/null
    then
        1>&2 echo "WARN: Undefined default gateway. Adding."
        cp $SHARED_DIR/51-gateway.yaml /etc/netplan
        netplan apply
    fi
}

apt-get-install() {
    DEBIAN_FRONTEND='noninteractive' apt-get install -y $@
}

apt-key-add() {
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -
}

setup_packages() {
    apt-get update

    # Package installer dependencies
    apt-get-install apt-transport-https

    # Wazuh required packages
    apt-get-install make gcc curl git automake autoconf libtool cmake lcov cppcheck astyle

    if [ "$VERSION_CODENAME" = "xenial" ]
    then
        apt-get-install policycoreutils clang
    else
        apt-get-install policycoreutils-python-utils clang-tools
    fi

    # Shell tools
    apt-get-install gdb valgrind net-tools psmisc tcpdump sqlite3 netcat-openbsd strace glibc-doc python3 python3-pip jq

    # Windows development toolchain

    if [ "$(uname -m)" = "x86_64" ]
    then
        dpkg --add-architecture i386
        apt-get update
        apt-get-install gcc-mingw-w64-i686 g++-mingw-w64-i686 nsis libcmocka-dev wine32
    fi
}

setup_cmocka_win() {
    git clone -b stable-1.1 https://git.cryptomilk.org/projects/cmocka.git
    sed -Ei 's/(BUILD_SHARED_LIBS .+) ON/\1 OFF/' cmocka/DefineOptions.cmake
    mkdir cmocka/build
    cd cmocka/build
    cmake -DCMAKE_C_COMPILER=i686-w64-mingw32-gcc -DCMAKE_C_LINK_EXECUTABLE=i686-w64-mingw32-ld -DCMAKE_INSTALL_PREFIX=/usr/i686-w64-mingw32/ -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_BUILD_TYPE=Release ..
    make
    make install
    cd ../..
    rm -r cmocka
}

setup_wazuh_repo() {
    curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key-add
    echo "deb https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list
}

setup_nfs() {
    apt-get-install nfs-kernel-server

    systemctl enable rpc-statd
    systemctl start rpc-statd
    echo "/ 192.168.33.1(rw,no_subtree_check,insecure,all_squash,anonuid=0,anongid=0)" > /etc/exports
    exportfs -ra
}

if [ -z "$sourced" ]
then
    setup_network
    setup_packages

    if [ "$(uname -m)" = "x86_64" ]
    then
        setup_cmocka_win
    fi

    setup_wazuh_repo
    setup_files
    setup_git
    setup_shell
    setup_ssh
    setup_timezone
    setup_nfs
    setup_cleanup
fi
