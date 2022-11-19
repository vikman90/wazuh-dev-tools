#! /bin/bash

# May 2, 2021

set -e

cd `dirname ${BASH_SOURCE[0]}`/../vagrant
export SHARED_DIR=`realpath shared`

sudo -E bash -c "source debian/setup.sh; setup_packages"
sudo -E bash -c "source debian/setup.sh; setup_cmocka_win"
sudo -E bash -c "source debian/setup.sh; setup_wazuh_repo"
sudo -E bash -c "source debian/setup.sh; setup_files"

source debian/setup.sh
setup_git
setup_shell
setup_ssh
