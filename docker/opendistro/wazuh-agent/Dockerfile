FROM ubuntu

ARG DEBIAN_FRONTEND="noninteractive"
ARG package_url="https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.0.3-1_amd64.deb"

RUN apt-get update && \
apt-get install -y curl lsb-release && \
curl -sLo wazuh-agent.deb $package_url && \
dpkg -i wazuh-agent.deb && \
apt-get purge -y curl && \
apt-get autoremove -y && \
rm -rf /var/lib/apt/lists/* && \
rm wazuh-agent.deb

ADD wazuh-agent.sh /usr/local/bin/wazuh-agent
ADD ossec.conf /var/ossec/etc/ossec.conf

CMD ["wazuh-agent"]
