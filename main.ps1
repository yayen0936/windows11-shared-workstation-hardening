# =============================
# Pre-Checks
# =============================
function Test-RunAsAdmin {
    $principal = New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    )

    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Write-Error "This script must be run as Administrator. Right-click PowerShell and choose 'Run as administrator'."
        exit 1
    }
}

# =============================
# Global paths
# =============================

# $PSScriptRoot points to src\
$Global:SrcRoot      = $PSScriptRoot
$Global:ProjectRoot  = Split-Path -Parent $Global:SrcRoot
$Global:ConfigRoot   = Join-Path $Global:SrcRoot 'config'
$Global:ControlsRoot = Join-Path $Global:SrcRoot 'controls'

# =============================
# Load submenu scripts
# =============================

. (Join-Path $Global:SrcRoot 'menus\Show-ComputerConfigMenu.ps1')
. (Join-Path $Global:SrcRoot 'menus\Show-UserConfigMenu.ps1')
. (Join-Path $Global:SrcRoot 'menus\Show-FileFolderStructureMenu.ps1')

# =============================
# Main menu function
# =============================
function Show-MainMenu {
    Clear-Host
    Write-Host "Windows 11 Shared Workstation Hardening" -ForegroundColor Cyan
    Write-Host "-------------------------------------------------"
    Write-Host "1) Computer Configuration"
    Write-Host "2) User Configuration"
    Write-Host "3) File & Folder Structure"
    Write-Host "0) Exit"
    Write-Host ""
}

# =============================
# Main script
# =============================

# Run Pre-Checks
Test-RunAsAdmin

# Main Menu loop
do {
    Show-MainMenu
    $choice = Read-Host "Select an option"

    switch ($choice) {
        '1' {
            Show-ComputerConfigMenu
        }
        '2' {
            Show-UserConfigMenu
        }
        '3' {
            Show-FileFolderStructureMenu
        }
        '0' {
            Write-Host "Exiting..." -ForegroundColor Yellow
        }
        default {
            Write-Host "Invalid selection. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
while ($choice -ne '0')