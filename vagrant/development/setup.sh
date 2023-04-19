#/bin/sh
# Debian
# July 25, 2022

[ $_ = $0 ] || sourced=0

set -e
source shared/shared.sh
source /etc/os-release

apt-get-install() {
    echo "Installing new package"
    DEBIAN_FRONTEND='noninteractive' apt-get install -y $@
}

apt-get-upgrade() {
    echo "Upgrading packages"
    DEBIAN_FRONTEND='noninteractive' apt-get upgrade -y
}

apt-get-update() {
    echo "Updating packages sources"
    apt-get update
}

apt-key-add() {
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -
}

setup_packages() {
    echo "Setting up packages"
    apt-get-update

    apt-get-install apt-transport-https
    apt-get-install nano
    apt-get-install curl
    apt-get-install wget
    apt-get-install git
    apt-get-install net-tools
    apt-get-install gnupg2
    apt-get-install ca-certificates
    apt-get-install lsb-release

    apt-get-install build-essential
    apt-get-install libssl-dev
    apt-get-install patchelf
    apt-get-install python3
    apt-get-install python3-pip
    apt-get-install net-tools
    apt-get-install cmake
    apt-get-install clang
    apt-get-install ninja-build
    apt-get-install mysql-server
    apt-get-install postgresql-client

    # VSCODE
    echo "Installing vscode"

    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF
    add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    apt-get-install code  

    # DOCKER
    echo "Installing docker"

    apt-get-upgrade
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get-update
    apt-get-install docker-ce docker-ce-cli containerd.io docker-compose-plugin

    sudo usermod -aG docker vagrant
    newgrp docker
}

setup_wazuh_repo() {
    curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key-add
    echo "deb https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list
}

setup_disk() {
    echo "Remember to execute this commands in order to update the disk size: "
    echo "sudo parted /dev/sda resizepart 3 100%"
    echo "sudo pvresize /dev/sda3"
    echo "sudo lvextend -l+100%FREE /dev/ubuntu-vg/ubuntu-lv"
    echo "sudo resize2fs /dev/ubuntu-vg/ubuntu-lv"    
}

if [ -z "$sourced" ]
then
    setup_packages
    setup_shared
    setup_disk
fi
