#!/bin/bash
# ================================
# Enable VRDP for all SOC VMs
# ================================

# Declare VM names and VRDP ports
declare -A vms
vms["SOC-DC01"]=5001
vms["SOC-Kali"]=5002
vms["SOC-Splunk"]=5003
vms["SOC-pfSense"]=5004
vms["SOC-Suricata"]=5005

for vm in "${!vms[@]}"; do
    port=${vms[$vm]}
    echo "Configuring VRDP for VM: $vm on port $port"

    # Enable VRDP
    VBoxManage modifyvm "$vm" --vrde on
    VBoxManage modifyvm "$vm" --vrdpport "$port"

    # Optional: enable encryption (recommended)
    VBoxManage modifyvm "$vm" --vrdpencryption 0
done

echo "VRDP setup complete. Connect with your RDP client to HOST_IP:VRDP_PORT."

