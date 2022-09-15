#/bin/sh
# Vikman Fernandez-Castro
# February 9, 2020

source shared/config.sh

if [ -z "$SHARED_DIR" ]
then
    1>&2 echo "ERROR: SHARED_DIR is undefined."
    exit 1
fi

version_le() {
    [ "$1" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}

setup_files() {
    if [ -f $SHARED_DIR/hosts ]
    then
        cat $SHARED_DIR/hosts >> /etc/hosts
    fi
}

setup_git() {
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    git config --global user.signingkey "$GIT_SIGNINGKEY"
    git config --global commit.gpgsign true
    git config --global color.ui true
    git config --global core.editor nano

    if version_le "git version 1.7.11" "`git --version`"
    then
        git config --global push.default simple
    fi

    # Ubuntu 20.10 - git version 2.27.0
    git config --global pull.rebase false

    gpg --batch --import $SHARED_DIR/private/gpg_key.asc
}

setup_ssh() {
    mkdir -p $HOME/.ssh
    chmod 700 ~/.ssh
    cp $SHARED_DIR/private/id_rsa* $HOME/.ssh
    cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/authorized_keys
    chmod 600 $HOME/.ssh/{id_rsa,authorized_keys}
}

setup_shell() {
    cp -rT /etc/skel $HOME
    cp $SHARED_DIR/wazuh_shell.sh $HOME/.wazuh_shell
    echo 'source $HOME/.wazuh_shell' >> $HOME/.bashrc
    echo 'export GPG_TTY=$(tty)' >> $HOME/.bashrc
}

setup_timezone() {
    timedatectl set-timezone $TIMEZONE
}

setup_cleanup() {
    rm -r $SHARED_DIR
}
