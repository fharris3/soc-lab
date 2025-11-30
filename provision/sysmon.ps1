Invoke-WebRequest https://download.sysinternals.com/files/Sysmon.zip -OutFile C:\sysmon.zip
Expand-Archive C:\sysmon.zip C:\sysmon
C:\sysmon\Sysmon64.exe -accepteula -i

