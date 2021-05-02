#! /bin/bash

# May 2, 2021

set -e

cd `dirname ${BASH_SOURCE[0]}`/../vagrant
export SHARED_DIR=`realpath shared`

sudo -E bash -c "source shared/setup_deb.sh; setup_packages"
sudo -E bash -c "source shared/setup_deb.sh; setup_python"
sudo -E bash -c "source shared/setup_deb.sh; setup_wazuh_repo"
sudo -E bash -c "source shared/setup_deb.sh; setup_files"

source shared/setup_deb.sh
setup_git
setup_shell
setup_ssh
