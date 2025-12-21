#!/bin/bash
set -e

# Configuration
MANAGER_HOSTNAME=${WAZUH_MANAGER:-"wazuh-manager"}

# Wait for manager to be available
echo "Waiting for Wazuh Manager ($MANAGER_HOSTNAME) to be reachable..."
until curl -k -s -XGET "https://$MANAGER_HOSTNAME:55000/manager/status" -u admin:admin > /dev/null 2>/dev/null; do
    sleep 5
done

# Configure the manager address
/var/ossec/bin/address-manager.sh "$MANAGER_HOSTNAME" || true
sed -i "s|<address>.*</address>|<address>$MANAGER_HOSTNAME</address>|" /var/ossec/etc/ossec.conf

# Start the agent
/var/ossec/bin/wazuh-control start

# Keep container running and stream logs
exec tail -f /var/ossec/logs/ossec.log
