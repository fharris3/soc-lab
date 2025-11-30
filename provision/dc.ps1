# ================================
# SOC DOMAIN CONTROLLER BUILD
# Windows Server 2022
# ================================

$ErrorActionPreference = "Stop"

Write-Host "=== Installing AD-Domain-Services ==="
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Secure DSRM Password
$SecurePass = ConvertTo-SecureString "P@ssw0rdAdmin!" -AsPlainText -Force

# Check if domain already exists (prevents re-running on reboot)
$domainExists = Get-ADDomain -ErrorAction SilentlyContinue
if ($null -eq $domainExists) {

    Write-Host "=== Promoting to Domain Controller ==="

    Install-ADDSForest `
        -DomainName "soc.lab" `
        -SafeModeAdministratorPassword $SecurePass `
        -InstallDNS `
        -DatabasePath "C:\Windows\NTDS" `
        -SysvolPath "C:\Windows\SYSVOL" `
        -LogPath "C:\Windows\NTDS" `
        -Force `
        -NoRebootOnCompletion

    Write-Host "=== Rebooting after Domain Promotion ==="
    Restart-Computer -Force
    exit
}

# ================================
# POST-DC CONFIG (SAFE RE-RUN)
# ================================

Write-Host "=== Creating SOC Organizational Units (Safe Mode) ==="

$baseDN = "DC=soc,DC=lab"

function Ensure-OU {
    param (
        [string]$Name,
        [string]$Path
    )

    $ou = Get-ADOrganizationalUnit -LDAPFilter "(ou=$Name)" -SearchBase $Path -ErrorAction SilentlyContinue
    if (-not $ou) {
        New-ADOrganizationalUnit -Name $Name -Path $Path -ProtectedFromAccidentalDeletion $true
        Write-Host "Created OU: $Name"
    } else {
        Write-Host "OU already exists: $Name"
    }
}

Ensure-OU "SOC" $baseDN
Ensure-OU "Servers" "OU=SOC,$baseDN"
Ensure-OU "Workstations" "OU=SOC,$baseDN"
Ensure-OU "ServiceAccounts" "OU=SOC,$baseDN"
Ensure-OU "SecurityGroups" "OU=SOC,$baseDN"

# ================================
# SECURITY GROUPS (SAFE MODE)
# ================================

Write-Host "=== Creating SOC Security Groups (Safe Mode) ==="

function Ensure-Group {
    param (
        [string]$Name,
        [string]$Path
    )

    $grp = Get-ADGroup -Filter "Name -eq '$Name'" -SearchBase $Path -ErrorAction SilentlyContinue
    if (-not $grp) {
        New-ADGroup -Name $Name -GroupScope Global -Path $Path
        Write-Host "Created group: $Name"
    } else {
        Write-Host "Group already exists: $Name"
    }
}

$groupPath = "OU=SecurityGroups,OU=SOC,$baseDN"

Ensure-Group "SOC-Admins"   $groupPath
Ensure-Group "SOC-Analysts" $groupPath
Ensure-Group "SOC-Servers"  $groupPath

# ================================
# SERVICE ACCOUNT (SAFE MODE)
# ================================

Write-Host "=== Creating SOC Service Account (Safe Mode) ==="

$userPath = "OU=ServiceAccounts,OU=SOC,$baseDN"

$svc = Get-ADUser -Filter "SamAccountName -eq 'svc-splunk'" -ErrorAction SilentlyContinue
if (-not $svc) {
    $svcPass = ConvertTo-SecureString "SplunkSvcP@ss!" -AsPlainText -Force

    New-ADUser `
      -Name "svc-splunk" `
      -SamAccountName "svc-splunk" `
      -AccountPassword $svcPass `
      -Enabled $true `
      -Path $userPath `
      -PasswordNeverExpires $true `
      -CannotChangePassword $true `
      -Description "Splunk Service Account"

    Write-Host "Created svc-splunk account"
} else {
    Write-Host "Service account already exists: svc-splunk"
}



# ================================
# WINDOWS EVENT FORWARDING (WEF)
# ================================

Write-Host "=== Enabling Windows Event Forwarding ==="
wecutil qc /q

Set-Service Wecsvc -StartupType Automatic
Start-Service Wecsvc

# ================================
# ADVANCED SECURITY LOGGING (SAFE MODE)
# ================================

Write-Host "=== Enabling Advanced Audit Policy (Server 2022 Safe Set) ==="

auditpol /set /subcategory:"Credential Validation" /success:enable /failure:enable
auditpol /set /subcategory:"Computer Account Management" /success:enable /failure:enable
auditpol /set /subcategory:"Security Group Management" /success:enable /failure:enable
auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable
auditpol /set /subcategory:"Logon" /success:enable /failure:enable
auditpol /set /subcategory:"Logoff" /success:enable /failure:enable
auditpol /set /subcategory:"Process Creation" /success:enable
auditpol /set /subcategory:"Audit Policy Change" /success:enable /failure:enable
auditpol /set /subcategory:"System Integrity" /success:enable /failure:enable

# ================================
# DNS HARDENING
# ================================

Write-Host "=== Hardening DNS ==="
Set-DnsServerRecursion -Enable $false
Set-DnsServerScavenging -ScavengingState $true

# ================================
# FINAL STATUS
# ================================

Write-Host "========================================"
Write-Host "SOC DOMAIN BUILD COMPLETE"
Write-Host "Domain: soc.lab"
Write-Host "Ready for Splunk / ELK / Suricata"
Write-Host "========================================"

