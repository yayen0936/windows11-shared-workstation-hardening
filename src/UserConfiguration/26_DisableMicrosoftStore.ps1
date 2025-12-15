param()

<#
.SYNOPSIS
    Disables Microsoft Store and consumer features.

.DESCRIPTION
    - Blocks Store app
    - Blocks consumer experiences (ads, suggestions)
#>

$StorePath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"

# FIX: Registry provider doesn't support -Recurse; ensure the key exists
if (-not (Test-Path $StorePath)) {
    New-Item -Path $StorePath -Force | Out-Null
}

# Disable Microsoft Store (machine-wide)
Set-ItemProperty -Path $StorePath -Name "RemoveWindowsStore" -Value 1 -Force
Set-ItemProperty -Path $StorePath -Name "DisableStoreApps"   -Value 1 -Force

# Disable consumer features (machine-wide)
$CE = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
if (-not (Test-Path $CE)) {
    New-Item -Path $CE -Force | Out-Null
}
Set-ItemProperty -Path $CE -Name "DisableConsumerFeatures" -Value 1 -Force

Write-Host "Microsoft Store and consumer features disabled." -ForegroundColor Green