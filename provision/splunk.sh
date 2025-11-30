#!/bin/bash
cd /tmp
wget -O splunk.tgz https://download.splunk.com/products/splunk/releases/9.0.0/linux/splunk-9.0.0-Linux-x86_64.tgz
tar -xzf splunk.tgz -C /opt
/opt/splunk/bin/splunk start --accept-license --no-prompt
/opt/splunk/bin/splunk enable boot-start
/opt/splunk/bin/splunk enable listen 9997 -auth admin:changeme

