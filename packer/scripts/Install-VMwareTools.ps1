# install vmware tools 10.1.7
$url = 'https://packages.vmware.com/tools/releases/10.1.10/windows/x64/VMware-tools-10.1.10-6082533-x86_64.exe'
$file = 'VMware-tools-10.1.7-5541682-x86_64.exe'
$path = "C:\Windows\Temp\$file"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url,$path)
$args = '/s /v /qn reboot=r'
Write-Output "Tools download successful.  Install starting."
Start-Process -FilePath $path -ArgumentList $args -PassThru

# & $path /s /v "/qn reboot=r"

$toolswait = $true

While ($toolswait){
    Try{
        if((Get-Service -Name VMTools -ErrorAction Stop).Status -eq "Running"){
            $toolswait = $false
        }
    } Catch {
        Write-Output "Waiting on tools install.  Sleeping 10s."
        Start-Sleep -Seconds 10
    }
}

Write-Output "Services started, sleeping 60 seconds for installer cleanup."
Start-Sleep -Seconds 60
