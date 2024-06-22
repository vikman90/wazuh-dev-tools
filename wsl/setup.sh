#! /bin/bash
# Vikman Fernandez-Castro
# May 2, 2021

set -e

os_family() {
    source /etc/os-release

    if [[ "$ID_LIKE" =~ "debian" ]]
    then
        echo "debian"
    elif [[ "$ID_LIKE" =~ "rhe" ]]
    then
        echo "redhat"
    else
        >&2 echo "ERROR: Unsupported distro: \"$ID_LIKE\""
        return 1
    fi
}

cd `dirname ${BASH_SOURCE[0]}`/../vagrant
export SHARED_DIR=`realpath shared`

distro=$(os_family)

# Must run as root

sudo -E bash <<EOF
    source $distro/setup.sh
    setup_packages
    setup_cmocka_win
    setup_wazuh_repo
    setup_files
EOF

source $distro/setup.sh
setup_git
setup_shell
setup_ssh
