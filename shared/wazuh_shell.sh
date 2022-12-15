# Set of aliases and functions
# Wazuh Inc.
# Aug 2022
#
# Rev 10
#
# Install:
# Go to the directory that contains this file and run:
# cp wazuh_shell.sh ~/.wazuh.sh && echo -e '\n. $HOME/.wazuh.sh' >> ~/.bashrc && . ~/.bashrc

# Set these values at your convenience
THREADS=$(nproc)
GIT_DEPTH=128

export PATH=$PATH:/var/ossec/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/var/ossec/lib

###########################
### wazuh/wazuh-content ###
###########################
git-clone-wazuh-content() {
    if [ -n "$1" ]
    then
        branch="-b $1"
        folder="wazuh-$1"
    else
        folder="wazuh-content"
    fi

    git clone --recurse-submodules -j$THREADS git@github.com:wazuh/wazuh-content $branch $folder
    cd $folder
    rootDir=$(pwd)

    # Compile http-request repo
    mkdir -p shared/http-request/build/ && cd "$_" && cmake .. -GNinja && ninja

    # Compile main repo
    cd $rootDir
    mkdir -p build && cd "$_" && cmake .. -GNinja && ninja    
}

alias cmake-content="cmake .. -GNinja"
alias cmake-content-debug="cmake .. -DCMAKE_BUILD_TYPE=Debug"

###################
### wazuh/wazuh ###
###################

alias make-agent="make -j$THREADS TARGET=agent"
alias make-agent-test="make-agent-debug TEST=1"
alias make-agent-debug="make-agent DEBUG=1"

alias make-server="make -j$THREADS TARGET=server"
alias make-server-test="make-server-debug TEST=1"
alias make-server-debug="make-server DEBUG=1"

alias make-local="make -j$THREADS TARGET=local"
alias make-local-test="make-local-debug TEST=1"
alias make-local-debug="make-local DEBUG=1"

alias make-winagent="make -j$THREADS TARGET=winagent"
alias make-winagent-test="make-winagent-debug TEST=1"
alias make-winagent-debug="make-winagent DEBUG=1"

alias make-test="make clean && make-server && make clean-internals && make-agent && make clean-internals && make-local && make clean && make-winagent && make clean"
alias make-docker="make SOURCE=$HOME/ossec-wazuh JOBS=$THREADS"

alias install-manager='USER_LANGUAGE="en" USER_NO_STOP="y" USER_INSTALL_TYPE="server" USER_DIR="/var/ossec" USER_ENABLE_EMAIL="n" USER_ENABLE_SYSCHECK="y" USER_ENABLE_ROOTCHECK="y" USER_WHITE_LIST="n" USER_ENABLE_SYSLOG="y" USER_ENABLE_AUTHD="y" USER_UPDATE="y" USER_AUTO_START="n" ./install.sh'

alias install-agent='USER_LANGUAGE="en" USER_NO_STOP="y" USER_INSTALL_TYPE="agent" USER_DIR="/var/ossec" USER_AGENT_SERVER_IP="groovy" USER_ENABLE_SYSCHECK="y" USER_ENABLE_ROOTCHECK="y" USER_ENABLE_ACTIVE_RESPONSE="y" USER_CA_STORE="n" USER_UPDATE="y" ./install.sh'

alias tail-ossec-json='tail -Fn1000 /var/ossec/logs/ossec.json'
alias tail-alerts="tail -Fn1000 /var/ossec/logs/alerts/alerts.log"
alias tail-alerts-json="tail -Fn1000 /var/ossec/logs/alerts/alerts.json"
alias tail-alerts-json-pretty='tail-alerts-json | jq'
alias tail-archives="tail -Fn1000 /var/ossec/logs/archives/archives.log"
alias tail-archives-json="tail -Fn1000 /var/ossec/logs/archives/archives.json"
alias tail-cluster="tail -Fn1000 /var/ossec/logs/cluster.log"
alias tail-api='tail -Fn1000 /var/ossec/logs/api.log'

alias nano-ossec='nano /var/ossec/etc/ossec.conf'
alias nano-internal='nano /var/ossec/etc/internal_options.conf'
alias nano-local-internal='nano /var/ossec/etc/local_internal_options.conf'

alias ossec-ssl="openssl req -x509 -batch -nodes -days 365 -newkey rsa:2048 -keyout /var/ossec/etc/sslmanager.key -out /var/ossec/etc/sslmanager.cert -subj \"/C=US/ST=CA/O=Wazuh\""
alias ossec-uninstall='ossec_uninstall'

alias valgrind="valgrind --leak-check=full --num-callers=20 --track-origins=yes"
alias valgrind-fds="valgrind --track-fds=yes --leak-check=full --num-callers=20 --track-origins=yes"
alias valgrind-all="valgrind --track-fds=yes --leak-check=full --show-leak-kinds=all --num-callers=20 --track-origins=yes"

alias docker-rm="docker rm -f \$(docker ps -aq) 2> /dev/null"
alias docker-rmi="docker rmi -f \$(docker images | awk '/^<none>/ {print \$3}') 2> /dev/null"
alias docker-run="docker run -it --rm"
alias watch-doc="make clean && make -j$THREADS html && while true; do inotifywait -re CLOSE_WRITE source; make -j$THREADS html; done"

alias vagrant-halt='vagrant global-status | grep running | cut -d" " -f1 | while read i; do vagrant halt $i; done'

alias scan-view='scan-view /tmp/scan-build-* --host 0.0.0.0 --port 80 --allow-all-hosts --no-browser'
alias scan-build='find /tmp -name "scan-build-*" -exec rm -r {} +; scan-build make -j$THREADS TARGET=server DEBUG=yes'

alias unit-tests='make clean-internals && make-server-test && cd unit_tests && mkdir -p build && cd build && cmake -DTARGET=server .. && make clean && make -j$THREADS && make test'

alias wazuh-api='curl -w\\n -sk -H "Authorization: Bearer $(curl -u wazuh:wazuh -sk -X GET "https://localhost:55000/security/user/authenticate?raw=true")"'

alias wazuh-manager-restart='sudo systemctl restart wazuh-manager'
alias wazuh-manager-status='sudo systemctl status wazuh-manager'
alias wazuh-manager-start='sudo systemctl start wazuh-manager'
alias wazuh-manager-stop='sudo systemctl stop wazuh-manager'

alias wazuh-indexer-restart='sudo systemctl restart wazuh-indexer'
alias wazuh-indexer-status='sudo systemctl status wazuh-indexer'
alias wazuh-indexer-start='sudo systemctl start wazuh-indexer'
alias wazuh-indexer-stop='sudo systemctl stop wazuh-indexer'

alias wazuh-dashboard-restart='sudo systemctl restart wazuh-dashboard'
alias wazuh-dashboard-status='sudo systemctl status wazuh-dashboard'
alias wazuh-dashboard-start='sudo systemctl start wazuh-dashboard'
alias wazuh-dashboard-stop='sudo systemctl stop wazuh-dashboard'

alias wazuh-server-restart='wazuh-dashboard-restart ; wazuh-indexer-restart ; wazuh-manager-restart'
alias wazuh-server-start='wazuh-dashboard-start ; wazuh-indexer-start ; wazuh-manager-start'
alias wazuh-server-stop='wazuh-dashboard-stop ; wazuh-indexer-stop ; wazuh-manager-stop'
alias wazuh-server-status='systemctl list-unit-files wazuh*'


git-clone-wazuh() {
    if [ -n "$1" ]
    then
        branch="-b $1"
        folder="wazuh-$1"
    else
        folder="wazuh"
    fi

    git clone git@github.com:wazuh/wazuh --depth $GIT_DEPTH $branch $folder
    cd $folder
}

git-add-branches() {
    git remote set-branches --add origin $@ && git fetch --depth $GIT_DEPTH
}

function compile() {
    gcc -pipe -O2 -Wall -Wextra -o $1 $1.c ${@:2}
}

function debug() {
    gcc -pipe -g -Wall -Wextra -o $1 $1.c ${@:2}
}

ossec_uninstall() {
    OSSEC_INIT="/etc/ossec-init.conf"

    # Try to get the installation directory

    if ! . $OSSEC_INIT 2> /dev/null
    then
        echo "Wazuh seems not to be installed. Removing anyway..."
        DIRECTORY="/var/ossec"
    fi

    # Stop service
    if [ $(uname) = "Linux" ]
    then
        service wazuh-manager stop 2> /dev/null
        service wazuh-agent stop 2> /dev/null
        service wazuh-api stop 2> /dev/null
    fi

    # Stop daemons
    $DIRECTORY/bin/ossec-control stop 2> /dev/null

    # Remove files and service artifacts
    rm -rf $DIRECTORY $OSSEC_INIT

    # Delete service

    case $(uname) in
    Linux)
        [ -f /etc/rc.local ] && sed -i'' '/ossec-control start/d' /etc/rc.local
        find /etc/{init.d,rc*.d} -name "*wazuh" | xargs rm -f

        if pidof systemd > /dev/null
        then
            find /etc/systemd/system -name "wazuh*" | xargs rm -f
            systemctl daemon-reload
        fi
        ;;
    Darwin)
        rm -rf /Library/StartupItems/OSSEC
        ;;
    SunOS)
        find /etc/{init.d,rc*.d} -name "*wazuh" | xargs rm -f
        ;;
    HP-UX)
        find /sbin/{init.d,rc*.d} -name "*wazuh" | xargs rm -f
        ;;
    AIX)
        find /etc/rc.d -name "*wazuh" | xargs rm -f
        ;;
    OpenBSD|NetBSD|FreeBSD|DragonFly)
        sed -i'' '/ossec-control start/d' /etc/rc.local
        ;;
    *)
        echo "ERROR: uname '$(uname)' not recognized. Could not remove service."
    esac

    # Delete users

    case $(uname) in
    Darwin)
        dscl . -delete "/Users/ossec" > /dev/null 2>&1
        dscl . -delete "/Users/ossecm" > /dev/null 2>&1
        dscl . -delete "/Users/ossecr" > /dev/null 2>&1
        dscl . -delete "/Groups/ossec" > /dev/null 2>&1
        ;;
    AIX)
        userdel ossec 2> /dev/null
        userdel ossecm 2> /dev/null
        userdel ossecr 2> /dev/null
        rmgroup ossec 2> /dev/null
        ;;
    *)
        userdel ossec 2> /dev/null
        userdel ossecm 2> /dev/null
        userdel ossecr 2> /dev/null
        groupdel ossec 2> /dev/null
    esac
}
