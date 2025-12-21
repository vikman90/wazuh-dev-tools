#!/bin/bash
set -e

# Wait for certificates to be available in the volume
while [ ! -f /tmp/wazuh-certs/indexer.pem ]; do
    echo "Waiting for certificates in /tmp/wazuh-certs/..."
    sleep 2
done

# Copy and configure certificates
cp /tmp/wazuh-certs/* /etc/wazuh-dashboard/certs/
chmod 500 /etc/wazuh-dashboard/certs
chmod 400 /etc/wazuh-dashboard/certs/*
chown -R wazuh-dashboard:wazuh-dashboard /etc/wazuh-dashboard/certs

# Configure dashboard
CONFIG_FILE="/etc/wazuh-dashboard/opensearch_dashboards.yml"
# Using alternative delimiters for sed to handle paths/URLs cleanly
sed -i 's|dashboard-key\.pem|indexer-key.pem|g' "$CONFIG_FILE"
sed -i 's|dashboard\.pem|indexer.pem|g' "$CONFIG_FILE"
sed -i 's|opensearch.hosts:.*|opensearch.hosts: https://wazuh-indexer:9200|g' "$CONFIG_FILE"
sed -i 's|url: https://localhost|url: https://wazuh-manager|g' "$CONFIG_FILE"

# Start as wazuh-dashboard user
exec runuser -u wazuh-dashboard -- /usr/share/wazuh-dashboard/bin/opensearch-dashboards
