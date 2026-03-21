#!/bin/bash
set -e

# Wait for certificates to be available in the volume
while [ ! -f /tmp/wazuh-certs/root-ca.pem ]; do
    echo "Waiting for certificates in /tmp/wazuh-certs/..."
    sleep 2
done

# Copy certificates to the expected location
mkdir -p /etc/wazuh-indexer/certs
cp /tmp/wazuh-certs/* /etc/wazuh-indexer/certs/
chmod 500 /etc/wazuh-indexer/certs
chmod 400 /etc/wazuh-indexer/certs/*

# Replace the existing <indexer> block with the correct configuration
CONF="/var/wazuh-manager/etc/wazuh-manager.conf"
sed -i '/<indexer>/,/<\/indexer>/c\
  <indexer>\
    <hosts>\
      <host>https://wazuh-indexer:9200</host>\
    </hosts>\
    <ssl>\
      <certificate_authorities>\
        <ca>/etc/wazuh-indexer/certs/root-ca.pem</ca>\
      </certificate_authorities>\
      <certificate>/etc/wazuh-indexer/certs/indexer.pem</certificate>\
      <key>/etc/wazuh-indexer/certs/indexer-key.pem</key>\
    </ssl>\
  </indexer>' "$CONF"

# Start Wazuh Manager
/var/wazuh-manager/bin/wazuh-manager-control start

# Keep container running by tailing the logs
exec tail -f /var/wazuh-manager/logs/wazuh-manager.log
