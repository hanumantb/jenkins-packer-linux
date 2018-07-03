# install windows managment framwork 5 on either server 20082 or server 2012r2

$wmi_operatingsystem = Get-WmiObject -Class win32_operatingsystem

switch ($wmi_operatingsystem.version)
{
    '6.3.9600' # Win8.1/2012R2
    {
        $url = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1AndW2K12R2-KB3134758-x64.msu'
    }
    '6.1.7601' # Win7 SP1/2008R2 SP1
    {
        Write-Host "Found Server 2008, downloading WMF5..."
        $url = 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7AndW2K8R2-KB3134760-x64.msu'
    }
}

Write-Host "Starting WMF5 Install..."
$file = Split-Path $url -Leaf
$path = "C:\Windows\Temp\$file"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url,$path)
$arg = '/quiet /norestart'
# & $path $arg
Start-Process -FilePath $path -ArgumentList $arg -Wait