#/bin/sh
# Gentoo
# July 25, 2022

[ $_ = $0 ] || sourced=0

set -e
source shared/shared.sh

setup_packages() {
    emerge dev-vcs/git nano
}

setup_nfs() {
    >&2 echo TODO: setup_nfs
    return
}

if [ -z "$sourced" ]
then
    setup_packages
    setup_files
    setup_git
    setup_shell
    setup_ssh
    setup_timezone
    setup_nfs
    setup_cleanup
fi
