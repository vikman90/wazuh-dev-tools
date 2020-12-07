#! /bin/bash

set -e
source /etc/ossec-init.conf

handler() {
    if [ -n "$filebeat_pid" ]
    then
        kill $filebeat_pid
    fi

    $DIRECTORY/bin/ossec-control stop

    exit
}

trap handler SIGINT
trap handler SIGTERM

if [ -n "$cluster_disabled" ]
then
    sed -i "s/node01/${HOSTNAME//\//\\\/}/" $DIRECTORY/etc/ossec.conf
else
    cluster_disabled="yes"
fi

sed -i "s/CLUSTER_DISABLED/${cluster_disabled//\//\\\/}/" $DIRECTORY/etc/ossec.conf

if [ -n "$cluster_type" ]
then
    sed -i "s/master/${cluster_type//\//\\\/}/" $DIRECTORY/etc/ossec.conf
fi

if [ -n "$cluster_master" ]
then
    sed -i "s/NODE_IP/${cluster_master//\//\\\/}/" $DIRECTORY/etc/ossec.conf
fi

$DIRECTORY/bin/wazuh-db
$DIRECTORY/bin/wazuh-modulesd
$DIRECTORY/bin/ossec-analysisd
$DIRECTORY/bin/ossec-remoted
$DIRECTORY/bin/ossec-monitord
$DIRECTORY/bin/ossec-authd
$DIRECTORY/bin/ossec-execd
$DIRECTORY/bin/wazuh-apid
$DIRECTORY/bin/wazuh-clusterd

if [ "$cluster_disabled" != "no" -o "$cluster_type" == "worker" ]
then
    filebeat &
    filebeat_pid=$!
fi

tail -f $DIRECTORY/logs/ossec.log &
wait
