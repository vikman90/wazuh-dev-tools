#! /bin/bash

set -e
DIRECTORY="/var/ossec"

if [ -z "$MANAGER_IP" ]
then
    >&2 echo "ERROR: Environment variable \"MANAGER_IP\" undeclared."
    exit 1
fi

handler() {
    $DIRECTORY/bin/wazuh-control stop
    exit
}

trap handler SIGINT
trap handler SIGTERM

sed -i "s/wazuh-worker/$MANAGER_IP/" $DIRECTORY/etc/ossec.conf
$DIRECTORY/bin/wazuh-control start

tail -f $DIRECTORY/logs/ossec.log &
wait
