# Wazuh Stack with Open Distro for Docker

## Basic steps

### Run stack on foreground

```sh
docker-compose up
```

### Access Kibana and Wazuh UI

Go to http://localhost:5601.

- User: `admin`
- Password: `admin`

## Further steps

### Run stack on background

```sh
docker-compose up -d
```

### Stop stack

We need to run this command if we started the stack on background.

```sh
docker-compose down
```

##  How to scale

We can scale the number of Wazuh workers and agents. For instance:

```sh
docker-compose up -d --scale wazuh-worker=2 --scale wazuh-agent=10
```
