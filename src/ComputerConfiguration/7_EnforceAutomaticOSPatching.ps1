param()

<#
.SYNOPSIS
    Enables and configures Automatic Windows Updates.

.DESCRIPTION
    Enforces automatic operating system patching by configuring Windows Update
    to download and install updates on a scheduled basis. This ensures the
    system receives timely security fixes, reduces exposure to known
    vulnerabilities, and supports a defense-in-depth strategy on shared
    workstations.
#>

$WUPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

# Ensure policy key exists
if (-not (Test-Path $WUPath)) {
    New-Item -Path $WUPath -Force | Out-Null
}

# Configure Automatic Updates
Set-ItemProperty -Path $WUPath -Name "AUOptions" -Value 4            # Auto download & schedule install
Set-ItemProperty -Path $WUPath -Name "ScheduledInstallDay" -Value 0  # Every day
Set-ItemProperty -Path $WUPath -Name "ScheduledInstallTime" -Value 3 # At 3 AM

Write-Host "Automatic Windows Updates configured!" -ForegroundColor Green