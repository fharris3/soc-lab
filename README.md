# 🛡️ SOC Home Lab – Enterprise Security Operations Center

This project builds a **full enterprise-grade SOC lab** using:

- Vagrant
- VirtualBox (headless)
- Windows Server 2022 (Active Directory)
- Kali Linux (attacker simulation)
- Splunk (SIEM)
- Suricata (IDS)
- pfSense (Firewall)

Designed for:
- Detection Engineering
- Purple Teaming
- Malware Analysis
- AD Attacks & Defense
- Log Correlation & SIEM Tuning

---

## 📦 SOC Architecture

| Host | Role | OS |
|------|------|----|
| dc01 | Domain Controller | Windows Server 2022 |
| kali | Attacker | Kali Linux |
| splunk | SIEM | Ubuntu 24.04 |
| suricata | IDS | Ubuntu 24.04 |
| pfsense | Firewall | FreeBSD |

---

## 🌐 Network Design

- All VMs use **bridged networking (`public_network`)**
- Each VM receives a **real LAN IP (10.0.0.0/24)**
- Fully reachable from GUI workstation via RDP/SSH
- No NAT or VRDE dependency

---

## 🚀 Deployment

### 1️⃣ Clone the Repo
```bash
git clone <your_repo_url>
cd soc_lab

2️⃣ Start the Lab

vagrant up

3️⃣ Access Systems
System	Access
Windows DC	RDP → 10.0.0.x
Kali	SSH or GUI
Splunk	http://10.0.0.x:8000
Suricata	SSH
pfSense	https://10.0.0.x
🔐 Default Credentials
System	User	Pass
Windows DC	vagrant	vagrant
Kali	kali	kali
pfSense	admin	pfsense
Splunk	admin	changeme

soc_lab/
├── Vagrantfile
├── provision/
│   ├── dc.ps1
│   ├── splunk.sh
│   ├── suricata.sh
│   └── elk.sh
├── .gitignore
└── README.md


