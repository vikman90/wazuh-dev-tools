#/bin/sh
# Archlinux
# July 25, 2022

[ $_ = $0 ] || sourced=0

set -e
source shared/shared.sh
source /etc/os-release

pacman-install() {
    pacman -Syu --noconfirm $@
}

setup_packages() {
    pacman -Syy

    pacman-install nano
    pacman-install curl
    pacman-install wget
    pacman-install git
    pacman-install net-tools
}

if [ -z "$sourced" ]
then
    setup_packages
    setup_shared
fi 
