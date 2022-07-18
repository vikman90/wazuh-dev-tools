#/bin/sh
# Vikman Fernandez-Castro
# June 4, 2020

set -e
source ../shared/shared.sh

setup_packages() {
    emerge dev-vcs/git nano
}

setup_python() {
    >&2 echo TODO: setup_python
    return
}

setup_nfs() {
    >&2 echo TODO: setup_nfs
    return
}

setup_packages
setup_python
setup_files
setup_git
setup_shell
setup_ssh
setup_timezone
setup_nfs
setup_cleanup
