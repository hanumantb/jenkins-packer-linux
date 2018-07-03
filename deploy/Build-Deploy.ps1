param(
    $OSVersion,
    $OutputDirectory = "D:\PackerBuilds\",
    $DestinationVCenter,
    [int]$NumTemplates = 2,
    [Switch]$RunVersioning
)

# .source Helper-Functions
. ./Helper-Functions.ps1

# Set up Packer json file name based on OSVersion
$packer_file = "03-$OSVersion-vsphere.json"

# Set packer log level
$env:PACKER_LOG=2

# Set up build
# TODO: Acutally implement this. & $env:packer_exe_path build -force -var-file=".\variables-global.json" -var "name=$OSVersion" -var "output_dir=$OutputDirectory" $packer_file

# Sleep to test waiting in jenkins
$random = Get-Random -Minimum 5 -Maximum 15
Write-Host "Sleeping for $random seconds"
Start-Sleep -Seconds $random

Write-Host "Deploy was successfull for $OSVersion to $DestinationVCenter with Templates to keep: $NumTemplates and versioning being $RunVersioning."

# Set last status
#TODO: Remove this after testing!
$rando = Get-Random -Minimum 1 -Maximum 3
if($rando -eq 1) {
    $Status = "SUCCEEDED"
} else {
    $Status = "FAILED"
}

Set-LastBuild -OSVersion $OSVersion -Status $Status -BuildDirectory $OutputDirectory -Task Deploy