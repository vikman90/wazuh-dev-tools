#!/bin/bash
set -e

# Wait for certificates to be available in the volume
while [ ! -f /tmp/wazuh-certs/root-ca.pem ]; do
    echo "Waiting for certificates in /tmp/wazuh-certs/..."
    sleep 2
done

# Copy certificates to the expected location
install -d -m 500 -o wazuh-manager -g wazuh-manager /var/wazuh-manager/etc/certs
install -m 400 -o wazuh-manager -g wazuh-manager /tmp/wazuh-certs/root-ca.pem /var/wazuh-manager/etc/certs/root-ca.pem
install -m 400 -o wazuh-manager -g wazuh-manager /tmp/wazuh-certs/admin.pem /var/wazuh-manager/etc/certs/manager.pem
install -m 400 -o wazuh-manager -g wazuh-manager /tmp/wazuh-certs/admin-key.pem /var/wazuh-manager/etc/certs/manager-key.pem

# Point indexer configuration to the Docker service name
CONF="/var/wazuh-manager/etc/wazuh-manager.conf"
sed -i 's|<host>https://127.0.0.1:9200</host>|<host>https://wazuh-indexer:9200</host>|g' "$CONF"

# Start Wazuh Manager
/var/wazuh-manager/bin/wazuh-manager-control start

# Keep container running by tailing the logs
exec tail -f /var/wazuh-manager/logs/wazuh-manager.log
