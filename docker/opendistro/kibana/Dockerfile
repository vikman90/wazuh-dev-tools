FROM amazon/opendistro-for-elasticsearch-kibana:1.11.0

ARG plugin_url="https://packages.wazuh.com/4.x/ui/kibana/wazuh_kibana-4.0.3_7.9.1-1.zip"

RUN kibana-plugin install $plugin_url

ADD --chown=kibana:root wazuh.yml /usr/share/kibana/optimize/wazuh/config/wazuh.yml
