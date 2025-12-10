# =============================
# Load submenu scripts
# =============================

$computer_path = Join-Path (Split-Path $PSScriptRoot -Parent) 'computer_policies'

. "$computer_path\1_AccountPasswordPolicy.ps1"
. "$computer_path\2_LocalAccountsLogon.ps1"
. "$computer_path\3_SystemHardeningEncryption.ps1"
. "$computer_path\4_NetworkFirewallRemote.ps1"

# =============================
# Computer Configuration menu function
# =============================
function Show-ComputerConfigMenu {
    Clear-Host
    Write-Host "Computer Configuration" -ForegroundColor Cyan
    Write-Host "-------------------------------------------------"
    Write-Host "1) Account & Password Policy"
    Write-Host "2) Local Accounts & Logon Settings"
    Write-Host "3) System Hardening & Encryption"
    Write-Host "4) Network, Firewall & Remote Access"
    Write-Host "0) Back to Main Menu"
    Write-Host ""
}

# =============================
# Computer Configuration submenu
# =============================

function Invoke-ComputerConfig {

    do {
        Show-ComputerConfigMenu
        $choice = Read-Host "Select an option"

        switch ($choice) {
            '1' {
                # Defined in computer_policies\1_AccountPasswordPolicy.ps1
                Show-AccountPasswordPolicy
            }
            '2' {
                # Defined in computer_policies\2_LocalAccountsLogon.ps1
                Show-LocalAccountsLogonSettings
            }
            '3' {
                # Defined in computer_policies\3_SystemHardeningEncryption.ps1
                Show-SystemHardeningAndEncryption
            }
            '4' {
                # Defined in computer_policies\4_NetworkFirewallRemote.ps1
                Show-NetworkFirewallRemoteAccess
            }
            '0' {
                Write-Host "Returning to main menu..." -ForegroundColor Yellow
            }
            default {
                Write-Host "Invalid selection. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
    while ($choice -ne '0')
}