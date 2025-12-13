param()

<#
.SYNOPSIS
    Blocks write access to removable disks (USB flash drives typically fall here).
#>

$ErrorActionPreference = 'Stop'

$BasePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices"
$RemovableDisksGuid = "{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}"
$PolicyPath = Join-Path $BasePath $RemovableDisksGuid

# Ensure path exists
if (-not (Test-Path $PolicyPath)) {
    New-Item -Path $PolicyPath -Force | Out-Null
}

# Set Deny_Write = 1
New-ItemProperty -Path $PolicyPath -Name "Deny_Write" -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host "Removable Disks: Deny write access has been set (Deny_Write=1)." -ForegroundColor Green
Write-Host "IMPORTANT: Unplug/replug the USB drive, then test writing again." -ForegroundColor Yellow
