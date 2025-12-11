param()

<#
.SYNOPSIS
    Disables AutoRun and AutoPlay.

.DESCRIPTION
    Prevents drive-by malware infections.
#>

$PolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"

Set-ItemProperty -Path $PolicyPath -Name "NoDriveTypeAutoRun" -Value 255 -Force
Set-ItemProperty -Path $PolicyPath -Name "NoAutoRun" -Value 1 -Force

Write-Host "AutoRun and AutoPlay disabled." -ForegroundColor Green
