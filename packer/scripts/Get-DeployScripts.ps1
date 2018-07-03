# stage a file that needs to be present in the template for our deployment process to succeed
New-Item -ItemType Directory -Path 'c:\' -Name 'deploy'
Invoke-WebRequest -Uri 'https://artifactory.davita.com/artifactory/win-binaries/scripts/vmwarerunonce/callps.bat' -OutFile 'c:\deploy\callps.bat'