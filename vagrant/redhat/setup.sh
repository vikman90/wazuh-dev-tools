#! /bin/bash
# Vikman Fernandez-Castro
# February 9, 2020

[ "$_" = "$0" ] || sourced=0

set -e
source shared/shared.sh

# Detect OS name and version
OS_NAME=$(sed 's/ release.*//' /etc/redhat-release)
OS_MAJOR=$(grep -oE '[0-9]+' /etc/redhat-release | head -n1)

if [ -z "$OS_NAME" ]
then
    >&2 echo "WARNING: cannot parse /etc/os-release (OS_NAME)"
    exit 1
fi

if [ -z "$OS_MAJOR" ]
then
    >&2 echo "ERROR: cannot parse /etc/redhat-release (OS_MAJOR)"
    exit 1
fi

yum-install() {
    yum install -y $@
}

setup_packages() {
    if [ "$OS_NAME" != "fedora" ]
    then
        if [ $OS_MAJOR -ge 9 ]
        then
            # PowerTools for Rocky Linux ≥ 9
            yum-install dnf-plugins-core
            dnf config-manager --enable crb
        elif [ $OS_MAJOR -eq 8 ]
        then
            # PowerTools for CentOS ≥ 8
            yum config-manager --set-enabled powertools
        fi

        if [ $OS_MAJOR -le 8 ]
        then
            # Set up Vault Mirror
            sed -i.bak 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
            sed -i.bak 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
        fi
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

setup_cmocka_win() {
    : # Not supported
}

setup_wazuh_repo() {
    cat > /etc/yum.repos.d/wazuh.repo <<\EOF
[wazuh_repo]
gpgcheck=1
gpgkey=https://packages.wazuh.com/key/GPG-KEY-WAZUH
enabled=1
name=Wazuh repository
baseurl=https://packages.wazuh.com/4.x/yum/
protect=1
EOF
}

setup_selinux() {
    if [ $OS_MAJOR = 6 ]
    then
        semanage fcontext -a -t ssh_home_t /root/.ssh
        restorecon -R -v /root/.ssh
    fi
}

setup_nfs() {
    yum-install nfs-utils

    if command -v systemctl > /dev/null
    then
        systemctl enable nfs-server
        systemctl start nfs-server
    else
        chkconfig nfs on
        service nfs start
    fi

    echo "/ 192.168.33.1(rw,no_subtree_check,insecure,all_squash,anonuid=0,anongid=0)" > /etc/exports
    exportfs -ra

    # Firewall

    # firewall-cmd --permanent --zone=public --add-service=nfs
    # firewall-cmd --permanent --zone=public --add-service=mountd
    # firewall-cmd --permanent --zone=public --add-service=rpc-bind
    # firewall-cmd --reload
}

if [ -z "$sourced" ]
then
    setup_packages
    setup_wazuh_repo
    setup_files
    setup_git
    setup_shell
    setup_ssh
    setup_selinux
    setup_timezone
    setup_nfs
    setup_cleanup
fi
