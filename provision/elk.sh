#!/bin/bash
apt update
apt install -y apt-transport-https curl gnupg

curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" \
 | tee /etc/apt/sources.list.d/elastic.list

apt update
apt install -y elasticsearch kibana logstash
systemctl enable --now elasticsearch kibana logstash

