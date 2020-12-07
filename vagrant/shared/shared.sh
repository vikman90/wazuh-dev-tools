#/bin/sh
# Vikman Fernandez-Castro
# February 9, 2020

source shared/config.sh

SHARED_DIR="/home/vagrant/shared"

setup_files() {
    cat $SHARED_DIR/hosts >> /etc/hosts
}

setup_git() {
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    git config --global user.signingkey "$GIT_SIGNINGKEY"
    git config --global commit.gpgsign true
    git config --global color.ui true
    git config --global core.editor nano
    git config --global push.default simple

    gpg --batch --import $SHARED_DIR/private/gpg_key.asc
}

setup_shell() {
    cp -rT /etc/skel /root
    cp $SHARED_DIR/wazuh_shell.sh /root/.wazuh_shell
    echo 'source /root/.wazuh_shell' >> /root/.bashrc
    echo 'export GPG_TTY=$(tty)' >> /root/.bashrc

    # Uncomment l* aliases [Debian]
    sed -i 's/^#\(alias l.*\)/\1/g' /root/.bashrc
}

setup_ssh() {
    mkdir -p /root/.ssh
    chmod 700 ~/.ssh
    cp $SHARED_DIR/private/id_rsa* /root/.ssh
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/{id_rsa,authorized_keys}
}

setup_timezone() {
    if command -v timedatectl > /dev/null
    then
        timedatectl set-timezone $TIMEZONE
    else
        ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    fi
}

setup_cleanup() {
    rm -r $SHARED_DIR
}
