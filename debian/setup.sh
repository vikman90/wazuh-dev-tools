#/bin/sh
# Debian
# July 25, 2022

[ $_ = $0 ] || sourced=0

set -e
source shared/shared.sh
source /etc/os-release

apt-get-install() {
    DEBIAN_FRONTEND='noninteractive' apt-get install -y $@
}

apt-key-add() {
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -
}

setup_packages() {
    dpkg --add-architecture i386
    apt-get update

    # Package installer dependencies
    apt-get-install apt-transport-https

    # Wazuh required packages
    apt-get-install make gcc curl git automake autoconf libtool gcc-mingw-w64-i686 g++-mingw-w64-i686 nsis cmake libcmocka-dev lcov wine32 cppcheck astyle

    if [ "$VERSION_CODENAME" = "xenial" ]
    then
        apt-get-install policycoreutils clang
    else
        apt-get-install policycoreutils-python-utils clang-tools
    fi

    # Shell tools
    apt-get-install gdb valgrind net-tools psmisc tcpdump sqlite3 netcat-openbsd strace glibc-doc python3 python3-pip
}

setup_nfs() {
    apt-get-install nfs-kernel-server

    systemctl enable rpc-statd
    systemctl start rpc-statd
    echo "/ 192.168.56.1(rw,no_subtree_check,insecure,all_squash,anonuid=0,anongid=0)" >> /etc/exports
    exportfs -ra
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
