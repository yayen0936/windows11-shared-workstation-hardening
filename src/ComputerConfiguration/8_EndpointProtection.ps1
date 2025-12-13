param()

<#
.SYNOPSIS
    Configures Microsoft Defender protection baselines.

.DESCRIPTION
    Enforces a baseline endpoint protection configuration for Microsoft Defender
    by enabling real-time malware protection, cloud-delivered threat intelligence,
    automatic sample submission, and scheduled scanning. These settings strengthen
    the system’s ability to detect, prevent, and respond to malicious activity,
    reducing the risk of malware compromise on shared workstations.
#>

# Enable Defender features
Set-MpPreference -DisableRealtimeMonitoring $false
Set-MpPreference -MAPSReporting 2
Set-MpPreference -SubmitSamplesConsent 1
Set-MpPreference -CheckForSignaturesBeforeRunningScan $true

# Daily quick scan at 2 AM
Set-MpPreference -ScanScheduleQuickScanTime 120

Write-Host "Microsoft Defender baseline applied!" -ForegroundColor Green
