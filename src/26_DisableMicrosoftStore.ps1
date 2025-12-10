param()

<#
.SYNOPSIS
    Disables Microsoft Store and consumer features.

.DESCRIPTION
    - Blocks Store app
    - Blocks consumer experiences (ads, suggestions)
#>

$StorePath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
New-Item -Path $StorePath -Recurse -Force | Out-Null

# Disable Microsoft Store
Set-ItemProperty -Path $StorePath -Name "RemoveWindowsStore" -Value 1 -Force
Set-ItemProperty -Path $StorePath -Name "DisableStoreApps" -Value 1 -Force

# Disable consumer features
$CE = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
New-Item -Path $CE -Force | Out-Null
Set-ItemProperty -Path $CE -Name "DisableConsumerFeatures" -Value 1 -Force

Write-Host "Microsoft Store and consumer features disabled." -ForegroundColor Green
