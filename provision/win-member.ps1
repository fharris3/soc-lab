Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.56.5

$cred = New-Object PSCredential("soc\Administrator",(ConvertTo-SecureString "P@ssw0rdAdmin!" -AsPlainText -Force))
Add-Computer -DomainName soc.lab -Credential $cred -Restart

