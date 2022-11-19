FROM ubuntu

ARG BRANCH=master

RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y wget unzip curl make cmake gcc g++ && \
wget -qO wazuh.zip https://github.com/wazuh/wazuh/archive/refs/heads/$BRANCH.zip && \
unzip wazuh.zip && \
USER_LANGUAGE="en" USER_NO_STOP="y" USER_INSTALL_TYPE="agent" USER_DIR="/var/ossec" USER_AGENT_SERVER_IP="wazuh-worker" USER_ENABLE_SYSCHECK="y" USER_ENABLE_ROOTCHECK="y" USER_ENABLE_ACTIVE_RESPONSE="y" USER_CA_STORE="n" USER_UPDATE="y" wazuh-$BRANCH/install.sh && \
apt-get purge -y wget unzip curl make cmake gcc g++ && \
apt-get autoremove -y && \
rm -rf /var/lib/apt/lists/* && \
rm wazuh.zip

# ADD ossec.conf /var/ossec/etc/ossec.conf
ADD wazuh-agent.sh /usr/local/bin/wazuh-agent

CMD ["wazuh-agent"]
