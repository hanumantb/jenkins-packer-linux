function Set-LastBuild {
    param(
        $OSVersion,
        [Parameter(Mandatory=$true)][ValidateSet("BuildOS", "Updates", "Deploy")]$Task,
        [Parameter(Mandatory=$true)][ValidateSet("SUCCEEDED", "FAILED")]$Status,
        $BuildDirectory
    )

    $FileName = "$OSVersion-$Task-LastRun.json"
    $obj = New-Object PSObject -Property @{
        Name = $OSVersion
        Status = $Status
        LastRunDate = Get-Date
        Task = $Task
    }

    $obj | ConvertTo-Json | Set-Content -Path "$BuildDirectory/$FileName" -Force
}