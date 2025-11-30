Invoke-WebRequest https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.10.0-windows-x86_64.zip -OutFile C:\wb.zip
Expand-Archive C:\wb.zip C:\winlogbeat

Set-Content C:\winlogbeat\winlogbeat.yml @"
winlogbeat.event_logs:
  - name: Security
output.logstash:
  hosts: ["192.168.56.60:5044"]
"@

C:\winlogbeat\install-service-winlogbeat.ps1
Start-Service winlogbeat

