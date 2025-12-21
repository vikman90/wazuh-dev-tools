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

# Remove existing indexer sections
while grep -q '<indexer>' /var/ossec/etc/ossec.conf; do
    sed -i '/<indexer>/,/<\/indexer>/d' /var/ossec/etc/ossec.conf
done

# Add indexer configuration
sed -i '0,/<\/ossec_config>/s|<\/ossec_config>|  <indexer>\
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
  </indexer>\
\
</ossec_config>|' /var/ossec/etc/ossec.conf

# Start and keep running
/var/ossec/bin/wazuh-control start
tail -f /var/ossec/logs/ossec.log
