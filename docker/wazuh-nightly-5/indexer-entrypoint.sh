#!/bin/bash
set -e

# Ensure permissions are correct
chown -R wazuh-indexer:wazuh-indexer /var/lib/wazuh-indexer
chown -R wazuh-indexer:wazuh-indexer /etc/wazuh-indexer/certs

# Start Wazuh Indexer in background
runuser -u wazuh-indexer -- /usr/share/wazuh-indexer/bin/opensearch &
INDEXER_PID=$!

# Initialize security on first run if needed
if [ ! -f /var/lib/wazuh-indexer/.security-initialized ]; then
    # Wait for indexer to be available
    until curl -XGET https://localhost:9200 -uadmin:admin -k -s -o /dev/null 2>/dev/null; do
        sleep 5
    done

    # Run security initialization using the official script
    /usr/share/wazuh-indexer/bin/indexer-security-init.sh
    touch /var/lib/wazuh-indexer/.security-initialized
fi

# Wait for indexer process
wait $INDEXER_PID
