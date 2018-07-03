param(
    $OSVersion,
    $OutputDirectory = "D:\PackerBuilds\",
    [Switch]$PackerDebug
)

# .source Helper-Functions
. ./Helper-Functions.ps1

# Change to the packer directory
Set-Location packer
Write-Host "Current directory is: $((Get-Location).path)"

# Set up Packer json file name based on OSVersion
$packer_file = "02-$OSVersion-updates.json"

# Set packer log level
$env:PACKER_LOG=1

# Set up build
if($PackerDebug) {
    & packer build -debug -force -var-file="variables-global.json" -var "name=$OSVersion" -var "output_dir=$OutputDirectory" $packer_file
}
& packer build -force -var-file="variables-global.json" -var "name=$OSVersion" -var "output_dir=$OutputDirectory" $packer_file

if($LastExitCode -eq 0) { # Run was successful
    Write-Host "Updates were successfull for $OSVersion."
    $status = "SUCCEEDED"
} else {
    Write-Host "Updates for $OSVersion FAILED."
    $status = "FAILED"
}

Set-LastBuild -OSVersion $OSVersion -Status $Status -BuildDirectory $OutputDirectory -Task Updates