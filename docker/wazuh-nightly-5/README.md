# Wazuh Server Docker Compose

This setup deploys Wazuh Server components (Indexer, Manager, and Dashboard) using Docker Compose.

## Structure

- **Wazuh Indexer**: OpenSearch-based indexing engine
- **Wazuh Manager**: Security event processing and analysis
- **Wazuh Dashboard**: Web UI for visualization and management

## Prerequisites

Ensure you have the following DEB packages in this directory:
- `wazuh-indexer*.deb`
- `wazuh-manager*.deb`
- `wazuh-dashboard*.deb`

## Usage

### Build and start all services

```bash
docker-compose up -d --build
```

### View logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f wazuh-indexer
docker-compose logs -f wazuh-manager
docker-compose logs -f wazuh-dashboard
```

### Stop services

```bash
docker-compose down
```

### Stop and remove volumes (complete cleanup)

```bash
docker-compose down -v
```

## Ports

- **9200**: Wazuh Indexer (HTTPS)
- **1514**: Wazuh Manager - Agent events (TCP/UDP)
- **1515**: Wazuh Manager - Agent registration
- **1516**: Wazuh Manager - Cluster communication
- **55000**: Wazuh Manager - API (HTTPS)
- **443**: Wazuh Dashboard (HTTPS)

## Shared Volumes

- `wazuh-certs`: Shared SSL/TLS certificates between components
- `indexer-data`: Wazuh Indexer data persistence
- `manager-data`: Wazuh Manager data persistence

## Notes

- Certificates are automatically generated during the first Indexer startup with `GENERATE_CERTS=true`
- All components share the `wazuh-certs` volume for certificate exchange
- The Manager and Dashboard wait for certificates to be available before starting
