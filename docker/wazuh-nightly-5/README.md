# Wazuh 5.0 Docker Stack

This project provides a fully optimized Docker Compose environment for Wazuh 5.0, including the Server stack and scalable Agents.

## Components

- **Wazuh Indexer**: Security event indexing engine.
- **Wazuh Manager**: Central processing and analysis core.
- **Wazuh Dashboard**: Visualization and management UI.
- **Wazuh Agent**: Scalable security endpoints.

## Usage

### 1. Launch the Server Stack
Starts the Indexer, Manager, and Dashboard.
```bash
docker compose up -d
```

### 2. Launch Agents (with Scaling)
Agents use the `agent` profile. You can scale them dynamically:
```bash
# Start 1 agent (default)
docker compose --profile agent up -d

# Start 5 agents (scaling)
docker compose --profile agent up -d --scale wazuh-agent=5
```

## Management

### View Logs
```bash
# Server logs
docker compose logs -f

# Agent logs
docker compose logs -f wazuh-agent
```

### Cleanup
```bash
# Stop all services
docker compose --profile agent down

# Complete removal (including data)
docker compose --profile agent down -v
```

## Configuration Note

- **Automatic Downloads**: Dockerfiles automatically download the latest 5.0 nightly builds.
- **Auto-Provisioning**: Certificates are generated on the first run; agents self-register with the manager on startup.
- **Ports**: 443 (Dashboard), 9200 (Indexer), 1514-1516/55000 (Manager).
