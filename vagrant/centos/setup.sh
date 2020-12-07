#/bin/sh
# Vikman Fernandez-Castro
# February 9, 2020

set -e
source shared/shared.sh

# Detect CentOS version
OS_VERSION=$(grep -oE '[0-9]+\.[0-9]+' /etc/centos-release)
OS_MAJOR=$(echo $OS_VERSION | cut -d. -f1)
[ -n "$OS_MAJOR" ]

yum-install() {
    yum install -y $@
}

setup_packages() {
    if [ $OS_MAJOR -ge 8 ]
    then
        yum config-manager --set-enabled PowerTools
    fi

    # Wazuh required packages
    yum-install make gcc git automake autoconf libtool checkpolicy nodejs npm libcmocka-devel

    # Shell tools
    yum-install gdb nano valgrind net-tools psmisc tcpdump git wget strace

    if [ $OS_MAJOR -ge 7 ]
    then
        yum-install policycoreutils
    else
        yum-install policycoreutils-python
    fi
}

setup_python() {
    yum-install epel-release python3 redhat-rpm-config python3-devel
    pip3 install jq pytest numpydoc psutil pytest-html jsonschema paramiko
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

setup_packages

if [ $OS_MAJOR -ge 7 ]
then
    setup_python
fi

setup_wazuh_repo
setup_files
setup_git
setup_shell
setup_ssh
setup_selinux
setup_timezone
setup_nfs
setup_cleanup
