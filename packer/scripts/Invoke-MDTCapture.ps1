# Script to set up, launch, and capture MDT WIM from packer process
param(
    $share_username, # Username with share write permissions
    $share_password, # Password that will be converted to credential object
    $capture_task, # TaskSequenceID of the capture task
    $share_domain, # Domain name
    $share_unc_path # Path to upload.
)

# $share_unc_path = "\\LAS1W1MDTSA01\TESTDeploymentShare$"
# Combine username and domain
$domain_user = "$share_domain\$share_username"
$pw = ConvertTo-SecureString -String $share_password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($domain_user,$pw)

# Attempt to connect to the Deployment Share
$share_psdrive = New-PSDrive -PSProvider FileSystem -Root $share_unc_path -Name "DeploymentShare" -Credential $cred

try {
    Test-Path -Path $share_unc_path
    Write-Host "Successfully connected to deployment share."
}
catch { # Exit if it can't access the path
    Write-Host "The credentials provided were incorrect.  Exiting."
    Exit 1
}

# Define path and arguments to execute the litetouch.vbs
Write-Host "Running MDT Capture Task Sequence."
$litetouch_args = "/TaskSequenceId:$capture_task /DoCapture:YES /SkipTaskSequence:YES /UserDomain:$share_domain /UserId:$share_username /UserPassword:$share_password /SkipComputerBackup:YES /SkipDeploymentTypes:YES /SkipSummary:YES /SkipApplications:YES /SkipBDDWelcome:YES /SkipComputerName:YES /SkipTimeZone:YES /SkipDomainMembership:YES /SkipFinalSummary:YES /SkipLocaleSelection:YES /SkipProductKey:YES /SkipAdminPassword:YES /SkipBitLocker:YES /SkipCapture:YES"
$litetouch_path = "$share_unc_path\Scripts\LiteTouch.vbs"

# Begin capture process
& $litetouch_path $litetouch_args
Write-Host "Successfully kicked off MDT Task."