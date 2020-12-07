#! /bin/bash

set -e
source /etc/ossec-init.conf

handler() {
    $DIRECTORY/bin/ossec-control stop

    exit
}

trap handler SIGINT
trap handler SIGTERM

$DIRECTORY/bin/ossec-control start

tail -f $DIRECTORY/logs/ossec.log &
wait
