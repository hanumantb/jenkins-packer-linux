Write-Host "Stopping WINRM before MDT reboot."
Start-Job -ScriptBlock {Start-Sleep -seconds 10; Stop-Service -Name winrm -force}
exit 0
