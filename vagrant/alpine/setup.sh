#! /bin/bash
# Vikman Fernandez-Castro
# November 19, 2022

set -e
source shared/shared.sh

setup_packages() {
    apk add git tzdata gpg gpg-agent python3 nano cmake
}

setup_nfs() {
    apk add nfs-utils

    echo "/ 192.168.33.1(rw,no_subtree_check,insecure,all_squash,anonuid=0,anongid=0)" >> /etc/exports
    exportfs -rav

    rc-update add nfs
    rc-service nfs start
}

setup_packages
setup_files
setup_git
setup_shell
setup_ssh
setup_timezone
setup_nfs
setup_cleanup