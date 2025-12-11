param()

<#
.SYNOPSIS
    Restricts access to Control Panel and the Settings app.

.DESCRIPTION
    Locks down Control Panel:
    - Prevents opening Control Panel
    - Prevents opening Settings app
    - Equivalent to GPO:
        User Configuration → Administrative Templates → Control Panel
#>

$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

# Create key if needed
if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }

# Disable Control Panel + Settings
Set-ItemProperty -Path $Path -Name "NoControlPanel" -Value 1 -Force

Write-Host "Control Panel and Settings access restricted." -ForegroundColor Green
