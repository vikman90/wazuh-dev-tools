#/bin/sh
# Vikman Fernandez-Castro
# February 8, 2020

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
    apt-get update

    # Package installer dependencies
    apt-get-install apt-transport-https

    # Wazuh required packages
    apt-get-install make gcc curl git automake autoconf libtool gcc-mingw-w64-i686 nsis nodejs npm cmake libcmocka-dev lcov

    if [ "$VERSION_CODENAME" = "xenial" ]
    then
        apt-get-install policycoreutils clang
    else
        apt-get-install policycoreutils-python-utils clang-tools
    fi

    # Shell tools
    apt-get-install gdb valgrind net-tools psmisc tcpdump sqlite3 netcat-openbsd strace glibc-doc
}

setup_python() {
    apt-get-install python3-pip

    # Ubuntu needs to enable the source repositories
    sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
    apt-get update
    apt-get build-dep -y python3

    pip3 install jq pytest numpydoc psutil pytest-html jsonschema paramiko
}

setup_wazuh_repo() {
    curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key-add
    echo "deb https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list
}

setup_nfs() {
    apt-get-install nfs-kernel-server

    systemctl enable rpc-statd
    systemctl start rpc-statd
    echo "/ 192.168.33.1(rw,no_subtree_check,insecure,all_squash,anonuid=0,anongid=0)" >> /etc/exports
    exportfs -ra
}

setup_packages
setup_python
setup_wazuh_repo
setup_files
setup_git
setup_shell
setup_ssh
setup_timezone
setup_nfs
setup_cleanup
