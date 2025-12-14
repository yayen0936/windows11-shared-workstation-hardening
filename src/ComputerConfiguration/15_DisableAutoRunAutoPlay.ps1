param()

<#
.SYNOPSIS
    Disables AutoRun and AutoPlay for removable media.

.DESCRIPTION
    Hardens the SecurePro Windows 11 shared workstation by preventing
    automatic execution of content from USB, CD/DVD, and other removable drives.

    This reduces the risk of:
    - Malware introduction from removable media
    - Drive-by execution when external devices are connected
#>

$PolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"

Set-ItemProperty -Path $PolicyPath -Name "NoDriveTypeAutoRun" -Value 255 -Force
Set-ItemProperty -Path $PolicyPath -Name "NoAutoRun" -Value 1 -Force

Write-Host "AutoRun and AutoPlay disabled." -ForegroundColor Green