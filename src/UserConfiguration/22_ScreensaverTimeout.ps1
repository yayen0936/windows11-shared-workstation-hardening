param()

<#
.SYNOPSIS
    Enforces password-protected screen saver with timeout.

.DESCRIPTION
    - 900 seconds = 15 minutes
    - Equivalent to GPO:
        User Configuration → Administrative Templates → Control Panel → Personalization
#>

$CP = "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop"

if (-not (Test-Path $CP)) {
    New-Item -Path $CP -Force | Out-Null
}

Set-ItemProperty -Path $CP -Name "ScreenSaveActive" -Value "1"
Set-ItemProperty -Path $CP -Name "ScreenSaverIsSecure" -Value "1"     # Require password
Set-ItemProperty -Path $CP -Name "ScreenSaveTimeOut" -Value "900"     # 15 minutes

Write-Host "Screen-saver lock and idle timeout configured." -ForegroundColor Green
