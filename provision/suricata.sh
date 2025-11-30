#!/bin/bash
apt update
apt install -y suricata jq
suricata-update
systemctl enable --now suricata

