#/bin/sh
# Redhat
# Sep 15, 2022

[ $_ = $0 ] || sourced=0

set -e
source shared/shared.sh

yum-install() {
    yum install -y $@
}

setup_packages() {
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
