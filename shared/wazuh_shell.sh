# Set of aliases and functions
# Wazuh Inc.
# May 22, 2016
#
# Rev 10
#
# Install:
# Go to the directory that contains this file and run:
# cp wazuh_shell.sh ~/.wazuh.sh && echo -e '\n. $HOME/.wazuh.sh' >> ~/.bashrc && . ~/.bashrc

# Set these values at your convenience
THREADS=1
GIT_DEPTH=128

if [ -z "$THREADS" ]
then
    case $(uname) in
    
    Linux)
        THREADS=$(grep processor /proc/cpuinfo | wc -l)
        ;;

    Darwin)

        THREADS=$(sysctl -n hw.ncpu)
        ;;

    *)
        THREADS=1
    esac
fi

export PATH=$PATH:/var/ossec/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/var/ossec/lib

## MAKE WAZUH PROJECT ##
alias make-agent="make -j$THREADS TARGET=agent"
alias make-server="make -j$THREADS TARGET=server"
alias make-local="make -j$THREADS TARGET=local"
alias make-winagent="make -j$THREADS TARGET=winagent"
alias make-agent-debug="make-agent DEBUG=yes"
alias make-server-debug="make-server DEBUG=yes"
alias make-local-debug="make-local DEBUG=yes"
alias make-winagent-debug="make-winagent DEBUG=yes"
alias make-agent-test="make-agent-debug TEST=1"
alias make-server-test="make-server-debug TEST=1"
alias make-local-test="make-local-debug TEST=1"
alias make-winagent-test="make-winagent-debug TEST=1"

alias install-manager='USER_LANGUAGE="en" USER_NO_STOP="y" USER_INSTALL_TYPE="server" USER_DIR="/var/ossec" USER_ENABLE_EMAIL="n" USER_ENABLE_SYSCHECK="y" USER_ENABLE_ROOTCHECK="y" USER_WHITE_LIST="n" USER_ENABLE_SYSLOG="y" USER_ENABLE_AUTHD="y" USER_UPDATE="y" USER_AUTO_START="n" ./install.sh'
alias install-agent='USER_LANGUAGE="en" USER_NO_STOP="y" USER_INSTALL_TYPE="agent" USER_DIR="/var/ossec" USER_AGENT_SERVER_IP="groovy" USER_ENABLE_SYSCHECK="y" USER_ENABLE_ROOTCHECK="y" USER_ENABLE_ACTIVE_RESPONSE="y" USER_CA_STORE="n" USER_UPDATE="y" ./install.sh'

alias make-test="make clean && make-server && make clean-internals && make-agent && make clean-internals && make-local && make clean && make-winagent && make clean"
alias make-docker="make SOURCE=$HOME/ossec-wazuh JOBS=$THREADS"

alias ossec-color='perl -pe '\''s-(\d+/\d+/\d+ \d+:\d+:\d+) ([^ \[]+)-\e[1m$1\e[0m \e[96m$2-g;s/(\[\d+\]) (\S+:\d+ at \S+:) /\e[35m$1 \e[90m$2\e[0m /g;s/ (DEBUG:) /\e[94m$&\e[0m/g;s/ (INFO:) /\e[32m$&\e[0m/g;s/ (WARNING:) /\e[33m$&\e[0m/g;s/ (ERROR:) /\e[31m$&\e[0m/g;s/ (CRITICAL)(:) / \e[41m$1\e[49;31m$2\e[0m /g'\'

case "$TERM" in
    xterm-color|*-256color) alias tail-ossec='tail -Fn1000 /var/ossec/logs/ossec.log | ossec-color';;
    *) alias tail-ossec='tail -Fn1000 /var/ossec/logs/ossec.log';;
esac

## PRINT LOGS ##
alias tail-ossec-json='tail -Fn1000 /var/ossec/logs/ossec.json'
alias tail-alerts="tail -Fn1000 /var/ossec/logs/alerts/alerts.log"
alias tail-alerts-json="tail -Fn1000 /var/ossec/logs/alerts/alerts.json"
alias tail-alerts-json-pretty='tail-alerts-json | while read i; do echo $i | python -m json.tool; done'
alias tail-archives="tail -Fn1000 /var/ossec/logs/archives/archives.log"
alias tail-archives-json="tail -Fn1000 /var/ossec/logs/archives/archives.json"
alias tail-cluster="tail -Fn1000 /var/ossec/logs/cluster.log"
alias tail-api='tail -Fn1000 /var/ossec/logs/api.log'

## EDIT FILES ##
alias nano-ossec='nano -Yxml /var/ossec/etc/ossec.conf'
alias nano-sh='nano -Ysh'
alias nano-internal='nano /var/ossec/etc/internal_options.conf'
alias nano-local-internal='nano /var/ossec/etc/local_internal_options.conf'

alias ossec-ssl="openssl req -x509 -batch -nodes -days 365 -newkey rsa:2048 -keyout /var/ossec/etc/sslmanager.key -out /var/ossec/etc/sslmanager.cert -subj \"/C=US/ST=CA/O=Wazuh\""
alias ossec-uninstall='ossec_uninstall'

## TESTING ##
alias unit-tests='make clean-internals && make-server-test && cd unit_tests && mkdir -p build && cd build && cmake -DTARGET=server .. && make clean && make -j$THREADS && make test'
alias scan-view='scan-view /tmp/scan-build-* --host 0.0.0.0 --port 80 --allow-all-hosts --no-browser'
alias scan-build='find /tmp -name "scan-build-*" -exec rm -r {} +; scan-build make -j$THREADS TARGET=server DEBUG=yes'

## VALGRIND ##
alias valgrind="valgrind --leak-check=full --num-callers=20 --track-origins=yes"
alias valgrind-fds="valgrind --track-fds=yes --leak-check=full --num-callers=20 --track-origins=yes"
alias valgrind-all="valgrind --track-fds=yes --leak-check=full --show-leak-kinds=all --num-callers=20 --track-origins=yes"

## VAGRANT ##
alias vagrant-halt='vagrant global-status | grep running | cut -d" " -f1 | while read i; do vagrant halt $i; done'

## DOCKER ##
alias docker-rm="docker rm -f \$(docker ps -aq) 2> /dev/null"
alias docker-rmi="docker rmi -f \$(docker images | awk '/^<none>/ {print \$3}') 2> /dev/null"
alias docker-run="docker run -it --rm"


alias wazuh-api='curl -w\\n -sk -H "Authorization: Bearer $(curl -u wazuh:wazuh -sk -X GET "https://localhost:55000/security/user/authenticate?raw=true")"'


## FUNCTIONS ##

git-clone-wazuh() {
    if [ -n "$1" ]
    then
        branch="-b $1"
        folder="wazuh-$1"
    else
        folder="wazuh"
    fi

    git clone git@github.com:wazuh/wazuh --depth $GIT_DEPTH $branch $folder
}

git-add-branches() {
    git remote set-branches --add origin $@ && git fetch --depth $GIT_DEPTH
}

function sgrep() {
    if [ "$2" = "" ]; then
        egrep -IRn "$1" .
    else
        egrep -IRn "$1" `find . -name "$2"`
    fi
}

function oc() {
    $@ 2>&1 | ossec-color
}

function compile() {
    gcc -pipe -O2 -Wall -Wextra -o $1 $1.c ${@:2}
}

function debug() {
    gcc -pipe -g -Wall -Wextra -o $1 $1.c ${@:2}
}

mkcd() {
    mkdir -p $1 && cd $1
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
