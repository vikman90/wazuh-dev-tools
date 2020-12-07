FROM ubuntu

ARG DEBIAN_FRONTEND="noninteractive"

ARG wazuh_deb="https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-manager/wazuh-manager_4.0.3-1_amd64.deb"
ARG wazuh_template="https://raw.githubusercontent.com/wazuh/wazuh/4.0/extensions/elasticsearch/7.x/wazuh-template.json"
ARG filebeat_deb="https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-7.9.1-amd64.deb"
ARG filebeat_mod="https://packages.wazuh.com/4.x/filebeat/wazuh-filebeat-0.1.tar.gz"

RUN apt-get update && \
apt-get install -y curl lsb-release && \
curl -o wazuh-manager.deb $wazuh_deb && \
curl -o filebeat.deb $filebeat_deb && \
dpkg -i wazuh-manager.deb filebeat.deb && \
curl -o /etc/filebeat/wazuh-template.json $wazuh_template && \
curl -s $filebeat_mod | tar -xvz -C /usr/share/filebeat/module && \
apt-get purge -y curl && \
apt-get autoremove -y && \
rm -rf /var/lib/apt/lists/* && \
rm wazuh-manager.deb filebeat.deb

ADD wazuh-manager.sh /usr/local/bin/wazuh-manager
ADD ossec.conf /var/ossec/etc/ossec.conf
ADD agent.conf /var/ossec/etc/shared/default/agent.conf
ADD filebeat.yml /etc/filebeat/filebeat.yml

CMD ["wazuh-manager"]

EXPOSE 1514/tcp
EXPOSE 1514/udp
EXPOSE 1515
EXPOSE 1516
EXPOSE 55000
