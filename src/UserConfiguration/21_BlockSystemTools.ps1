param()

<#
.SYNOPSIS
    Blocks system administration tools for standard users.

.DESCRIPTION
    Blocks:
    - CMD
    - PowerShell
    - Registry Editor
#>

$Policies = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies"

# Block CMD
Set-ItemProperty -Path "$Policies\System" -Name "DisableCMD" -Value 2 -Force

# Block PowerShell by execution policy (user scope)
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted -Force

# Block regedit
if (-not (Test-Path "$Policies\System")) {
    New-Item -Path "$Policies\System" -Force | Out-Null
}
Set-ItemProperty -Path "$Policies\System" -Name "DisableRegistryTools" -Value 1 -Force

Write-Host "System tools (CMD, PowerShell, regedit) blocked for standard users." -ForegroundColor Green
