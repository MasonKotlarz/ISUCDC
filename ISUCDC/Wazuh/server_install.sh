read -p "Do you want to enable Active Response (y/N): " ar
read -p "Wazuh version: " version
read -p "Proxy address: " proxy

curl -sO https://packages.wazuh.com/$version/wazuh-install.sh
echo -e "export HTTPS_PROXY=$proxy\nexport NO_PROXY=localhost,127.0.0.1" | cat - wazuh-install.sh > install.sh
bash ./install.sh -a

cp config/agent.conf /var/ossec/etc/shared/default
cp config/*.xml /var/ossec/etc/rules
cp config/audit-key-categories /var/ossec/etc/lists
chown wazuh:wazuh /var/ossec/etc/lists/audit-key-categories
chmod 660 /var/ossec/etc/lists/audit-key-categories

sed -i '/<list>etc\/lists\/security-eventchannel<\/list>/ a\ \ \ \ <list>etc/lists/audit-key-categories</list>' /var/ossec/etc/ossec.conf

systemctl restart wazuh-manager