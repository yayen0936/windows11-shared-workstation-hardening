param()

<#
.SYNOPSIS
    Restricts access to drives in File Explorer.

.DESCRIPTION
    Hides C: drive and prevents browsing into restricted drives.
    Bitmask 04 = hide "C:" only
#>

$Explorer = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

if (-not (Test-Path $Explorer)) { New-Item -Path $Explorer -Force | Out-Null }

# Hide C: drive (bitmask 4)
Set-ItemProperty -Path $Explorer -Name "NoViewOnDrive" -Value 4 -Force
Set-ItemProperty -Path $Explorer -Name "NoViewOnDrives" -Value 4 -Force

Write-Host "Drive visibility restrictions applied." -ForegroundColor Green
