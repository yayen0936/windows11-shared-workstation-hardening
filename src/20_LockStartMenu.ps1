param()

<#
.SYNOPSIS
    Restricts Start menu and taskbar customization.

.DESCRIPTION
    - Removes Run command
    - Hides administrative tools
    - Blocks user customization
#>

$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }

Set-ItemProperty -Path $Path -Name "NoRun" -Value 1 -Force
Set-ItemProperty -Path $Path -Name "NoSetTaskbar" -Value 1 -Force
Set-ItemProperty -Path $Path -Name "StartMenuLogOff" -Value 1 -Force
Set-ItemProperty -Path $Path -Name "NoChangeStartMenu" -Value 1 -Force
Set-ItemProperty -Path $Path -Name "NoCommonGroups" -Value 1 -Force

Write-Host "Start menu and taskbar lockdown applied." -ForegroundColor Green
