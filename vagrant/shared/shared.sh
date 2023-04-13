#/bin/sh
# Vikman Fernandez-Castro
# February 9, 2020

source shared/config.sh

if [ -z "$SHARED_DIR" ]
then
    1>&2 echo "ERROR: SHARED_DIR is undefined."
    exit 1
fi

setup_hosts() {
    echo "Setting up hosts configurations"

    cat $SHARED_DIR/hosts >> /etc/hosts
}

setup_ssh() {
    echo "Setting up ssh configurations"

    SSH_DIR="/home/vagrant/.ssh"
    
    # Add host keys to the VM
    cp $SHARED_DIR/private/id_rsa* $SSH_DIR

    # Set permissions
    chown vagrant:vagrant $SSH_DIR/id_rsa*
    chmod 644 $SSH_DIR/id_rsa.pub
    chmod 600 $SSH_DIR/id_rsa

    # Add host to the authorized keys
    cat $SSH_DIR/id_rsa.pub >> $SSH_DIR/authorized_keys  
}

setup_git() {
    echo "Setting up git configurations"

    cat $SHARED_DIR/private/.gitconfig > /home/vagrant/.gitconfig
    gpg --batch --import $SHARED_DIR/private/gpg_key.asc
}

setup_timezone() {
    echo "Setting up timezone configurations"

    timedatectl set-timezone $TIMEZONE
}

setup_cleanup() {
    echo "Cleanup"

    rm -r $SHARED_DIR
}

setup_shared() {
    echo "Setting up shared configurations"
    setup_ssh
    setup_git
    setup_hosts
    setup_timezone
    setup_cleanup
}
