#/bin/sh
# Redhat
# July 25, 2022

[ $_ = $0 ] || sourced=0

set -e
source shared/shared.sh

# Detect CentOS version
RELEASE_VERSION=$(grep -oE '[0-9]+' /etc/centos-release | head -n1)

if [ -z "$OS_MAJOR" ]
then
    >&2 echo "ERROR: cannot parse /etc/centos-release (OS_MAJOR)"
    exit 1
fi

yum-install() {
    yum install -y $@
}

setup_packages() {
    [ $RELEASE_VERSION -eq 9 ] && yum config-manager --set-enabled crb
    [ $RELEASE_VERSION -eq 8 ] && yum config-manager --set-enabled powertools

    # Wazuh required packages
    yum-install nano
    yum-install curl
    yum-install wget
    yum-install git
    yum-install net-tools
    yum-install gnupg2
}

if [ -z "$sourced" ]
then
    setup_packages
    setup_shared
fi
