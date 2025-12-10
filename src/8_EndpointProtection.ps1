param()

<#
.SYNOPSIS
    Configures Microsoft Defender protection baselines.

.DESCRIPTION
    Equivalent to:
    Windows Security -> Virus & Threat Protection settings

    - Real-time protection
    - Cloud protection
    - Automatic sample submission
    - Scheduled scanning
#>

# Enable Defender features
Set-MpPreference -DisableRealtimeMonitoring $false
Set-MpPreference -MAPSReporting 2
Set-MpPreference -SubmitSamplesConsent 1
Set-MpPreference -CheckForSignaturesBeforeRunningScan $true

# Daily quick scan at 2 AM
Set-MpPreference -ScanScheduleQuickScanTime 120

Write-Host "Microsoft Defender baseline applied!" -ForegroundColor Green
