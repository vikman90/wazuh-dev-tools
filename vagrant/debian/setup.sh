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

apt-get-upgrade() {
    DEBIAN_FRONTEND='noninteractive' apt-get upgrade -y
}

apt-key-add() {
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -
}

setup_packages() {
    apt-get update

    apt-get-install apt-transport-https
    apt-get-install nano
    apt-get-install curl
    apt-get-install wget
    apt-get-install git
    apt-get-install net-tools
    apt-get-install gnupg2

    apt-get-upgrade
}

setup_wazuh_repo() {
    curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key-add
    echo "deb https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list
}

setup_dev() {
    apt-get update

    apt-get-install build-essential
    apt-get-install libssl-dev
    apt-get-install python3
    apt-get-install python3-pip
    apt-get-install net-tools
    apt-get-install gnupg2
    apt-get-install cmake
    apt-get-install clang
    apt-get-install ninja-build
    apt-get-install mysql-server
    apt-get-install postgresql-client

    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF
    add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    apt-get-install code    
}

if [ -z "$sourced" ]
then
    setup_packages
    setup_shared
    if [ "$1" == "development" ]; then 
        setup_dev    
    fi
fi
