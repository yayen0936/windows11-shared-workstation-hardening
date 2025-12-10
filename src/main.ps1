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
# Load submenu scripts
# =============================
. "$PSScriptRoot\submenu\1_ComputerConfiguration.ps1"
. "$PSScriptRoot\submenu\2_UserConfiguration.ps1"
. "$PSScriptRoot\submenu\3_FileSystem.ps1"

# =============================
# Main menu function
# =============================
function Show-MainMenu {
    Clear-Host
    Write-Host "Windows 11 Shared Workstation Hardening" -ForegroundColor Cyan
    Write-Host "-------------------------------------------------"
    Write-Host "1) Computer Configuration"
    Write-Host "2) User Configuration"
    Write-Host "3) File System & Data Access Controls"
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
        '1' { Invoke-ComputerConfig }
        '2' { Show-UserConfigMenu }
        '3' { Show-FileSystemMenu }
        '0' { Write-Host "Exiting..." -ForegroundColor Yellow }
        default {
            Write-Host "Invalid selection. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
while ($choice -ne '0')