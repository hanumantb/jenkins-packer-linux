# Grab environment vars from packer
$share_username = $env:SHARE_USERNAME
$share_password = $env:SHARE_PASSWORD
$capture_task = $env:CAPTURE_TASK
$share_domain = $env:SHARE_DOMAIN
$share_unc_path = $env:SHARE_UNC_PATH

& A:\Invoke-MDTCapture.ps1 -share_username $share_username `
-share_password $share_password `
-capture_task $capture_task `
-share_domain $share_domain `
-share_unc_path $share_unc_path

exit 0
