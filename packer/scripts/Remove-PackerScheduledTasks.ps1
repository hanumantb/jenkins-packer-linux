$wmi_operatingsystem = Get-WmiObject -Class win32_operatingsystem

switch ($wmi_operatingsystem.version)
{
    '6.3.9600' # Win8.1/2012R2
    {
        Write-Output "Removing packer scheduled tasks for 2012R2."
        Get-ScheduledTask | where {$_.TaskName -match "packer"} | Unregister-ScheduledTask -Confirm:$false
    }
    '6.1.7601' # Win7 SP1/2008R2 SP1
    {
        Write-Output "Removing packer scheduled tasks for 2008R2 using COM Object."
        ($TaskScheduler = New-Object -ComObject Schedule.Service).Connect("localhost")
        $TFolder = $TaskScheduler.GetFolder('\')
        $PackerTasks = $TFolder.GetTasks(1) | Where {$_.Name -match "packer"}
        
        Foreach($ptask in $PackerTasks){
            $TFolder.DeleteTask($ptask.Path, 0)
        }
    }
}