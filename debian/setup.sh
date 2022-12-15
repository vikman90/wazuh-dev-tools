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

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    apt-get-install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    apt-get update update
    apt-get-install code
}

if [ -z "$sourced" ]
then
    setup_packages
    setup_wazuh_repo
    setup_files
    setup_git
    setup_shell
    setup_ssh
    setup_timezone
    setup_cleanup
    
    [ "$1" == "development" ] && echo "Setting up development machine..." && setup_dev    
fi
