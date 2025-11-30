Vagrant.configure("2") do |config|

  ############################
  # GLOBAL SETTINGS
  ############################
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  ############################
  # KALI ATTACKER
  ############################
  config.vm.define "kali" do |kali|
    kali.vm.box = "kalilinux/rolling"
    kali.vm.hostname = "kali"
    kali.vm.network "private_network", ip: "192.168.56.10"
    kali.vm.provider "virtualbox" do |vb|
      vb.name = "SOC-Kali"
      vb.memory = 4096
      vb.cpus = 2
    end
  end

############################
# WINDOWS DOMAIN CONTROLLER
############################
config.vm.define "dc01" do |dc01|
  dc01.vm.box = "jborean93/WindowsServer2022"
  dc01.vm.hostname = "dc01"

  dc01.vm.network "private_network", ip: "192.168.56.5"
  dc01.vm.network "forwarded_port", guest: 3389, host: 3390, auto_correct: true

  dc01.vm.provider "virtualbox" do |vb|
    vb.name = "SOC-DC01"
    vb.memory = 4096
    vb.cpus = 2
  end

  dc01.vm.provision "shell", path: "provision/dc.ps1"
end


  ############################
  # WINDOWS DOMAIN MEMBER
  ############################
  config.vm.define "win2022" do |win|
    win.vm.box = "mwrock/Windows2022"
    win.vm.hostname = "win2022"
    win.vm.network "private_network", ip: "192.168.56.20"
    win.vm.network "forwarded_port", guest: 3389, host: 3390
    win.vm.provider "virtualbox" do |vb|
      vb.name = "SOC-WIN2022"
      vb.memory = 8192
      vb.cpus = 4
    end
    win.vm.provision "shell", path: "provision/win-member.ps1"
    win.vm.provision "shell", path: "provision/sysmon.ps1"
    win.vm.provision "shell", path: "provision/winlogbeat.ps1"
  end

  ############################
  # SURICATA IDS
  ############################
  config.vm.define "suricata" do |ids|
    ids.vm.box = "ubuntu/jammy64"
    ids.vm.hostname = "suricata"
    ids.vm.network "private_network", ip: "192.168.56.50"
    ids.vm.provider "virtualbox" do |vb|
      vb.name = "SOC-Suricata"
      vb.memory = 4096
      vb.cpus = 2
    end
    ids.vm.provision "shell", path: "provision/suricata.sh"
  end

  ############################
  # ELK STACK
  ############################
  config.vm.define "elk" do |elk|
    elk.vm.box = "ubuntu/jammy64"
    elk.vm.hostname = "elk"
    elk.vm.network "private_network", ip: "192.168.56.60"
    elk.vm.network "forwarded_port", guest: 5601, host: 5601
    elk.vm.provider "virtualbox" do |vb|
      vb.name = "SOC-ELK"
      vb.memory = 8192
      vb.cpus = 4
    end
    elk.vm.provision "shell", path: "provision/elk.sh"
  end

  ############################
  # SPLUNK
  ############################
  config.vm.define "splunk" do |splunk|
    splunk.vm.box = "ubuntu/jammy64"
    splunk.vm.hostname = "splunk"
    splunk.vm.network "private_network", ip: "192.168.56.40"
    splunk.vm.network "forwarded_port", guest: 8000, host: 8000
    splunk.vm.provider "virtualbox" do |vb|
      vb.name = "SOC-Splunk"
      vb.memory = 8192
      vb.cpus = 4
    end
    splunk.vm.provision "shell", path: "provision/splunk.sh"
  end

end

