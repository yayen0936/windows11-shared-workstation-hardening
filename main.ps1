###############################################
# MAIN MENU
###############################################
function Show-MainMenu {
    Clear-Host
    Write-Host "============================================="
    Write-Host "        Workstation Security Hardening" -ForegroundColor Cyan
    Write-Host "============================================="
    Write-Host ""
    Write-Host "1) Computer Configuration"
    Write-Host "2) User Configuration"
    Write-Host "3) File and Folder Structure"
    Write-Host ""
    Write-Host "Q) Quit"
    Write-Host ""
}

###############################################
# COMPUTER CONFIGURATION MENU
###############################################
function Show-ComputerConfigMenu {
    Clear-Host
    Write-Host "============================================="
    Write-Host "        Computer Configuration"     -ForegroundColor Green
    Write-Host "============================================="
    Write-Host ""
    Write-Host "  1  - Strong local password policy"
    Write-Host "  2  - Account lockout policy"
    Write-Host "  3  - Minimize local Administrators group"
    Write-Host "  4  - Harden built-in accounts"
    Write-Host "  5  - Secure logon options"
    Write-Host "  6  - Strong User Account Control (UAC)"
    Write-Host "  7  - Automatic OS patching (Windows Update)"
    Write-Host "  8  - Endpoint protection (Microsoft Defender)"
    Write-Host "  9  - SmartScreen / reputation protection"
    Write-Host "  10 - Windows Firewall baseline"
    Write-Host "  11 - Secure or disable remote access (RDP/WinRM)"
    Write-Host "  12 - BitLocker disk encryption"
    Write-Host "  13 - USB and removable media controls"
    Write-Host "  14 - Disable unnecessary services"
    Write-Host "  15 - Disable AutoRun and AutoPlay"
    Write-Host "  16 - Audit policy and log retention"
    Write-Host "  17 - Application control (AppLocker / WDAC)"
    Write-Host "  18 - BIOS/UEFI and boot security"
    Write-Host ""
    Write-Host "B) Back"
    Write-Host ""
}

###############################################
# USER CONFIGURATION MENU
###############################################
function Show-UserConfigMenu {
    Clear-Host
    Write-Host "============================================="
    Write-Host "            User Configuration"     -ForegroundColor Green
    Write-Host "============================================="
    Write-Host ""
    Write-Host "  19 - Restrict Control Panel and Settings"
    Write-Host "  20 - Lock Start menu and taskbar"
    Write-Host "  21 - Block cmd, PowerShell, regedit"
    Write-Host "  22 - Screen saver lock and idle timeout"
    Write-Host "  23 - Restrict drive visibility and access"
    Write-Host "  24 - Harden browser settings"
    Write-Host "  25 - Logon/logoff scripts"
    Write-Host "  26 - Disable Microsoft Store features"
    Write-Host ""
    Write-Host "B) Back"
    Write-Host ""
}

###############################################
# FILE & FOLDER STRUCTURE MENU
###############################################
function Show-FileFolderMenu {
    Clear-Host
    Write-Host "============================================="
    Write-Host "          File and Folder Structure"    -ForegroundColor Green
    Write-Host "============================================="
    Write-Host ""
    Write-Host "  27 - Group-based access model (RBAC)"
    Write-Host "  28 - Least privilege NTFS permissions"
    Write-Host "  29 - Folder ACLs with controlled inheritance"
    Write-Host "  30 - File access auditing"
    Write-Host ""
    Write-Host "B) Back"
    Write-Host ""
}

###############################################
# PROCESS SELECTION
###############################################
function Process-Selection {
    param([string]$choice)

    switch ($choice) {

        # Computer Config
        "1"  { "Selected: Strong local password policy" }
        "2"  { "Selected: Account lockout policy" }
        "3"  { "Selected: Minimize local Administrators group" }
        "4"  { "Selected: Harden built-in accounts" }
        "5"  { "Selected: Secure logon options" }
        "6"  { "Selected: Strong User Account Control" }
        "7"  { "Selected: Automatic OS patching" }
        "8"  { "Selected: Endpoint protection (Defender)" }
        "9"  { "Selected: SmartScreen protection" }
        "10" { "Selected: Windows Firewall baseline" }
        "11" { "Selected: Secure or disable remote access" }
        "12" { "Selected: BitLocker encryption" }
        "13" { "Selected: USB/removable media controls" }
        "14" { "Selected: Disable unnecessary services" }
        "15" { "Selected: Disable AutoRun/AutoPlay" }
        "16" { "Selected: Audit policy & log retention" }
        "17" { "Selected: Application control (AppLocker/WDAC)" }
        "18" { "Selected: BIOS/UEFI and boot security" }

        # User Config
        "19" { "Selected: Restrict Control Panel/Settings" }
        "20" { "Selected: Lock Start menu and taskbar" }
        "21" { "Selected: Block cmd, PowerShell, regedit" }
        "22" { "Selected: Screen saver & idle timeout" }
        "23" { "Selected: Restrict drive visibility" }
        "24" { "Selected: Harden browser settings" }
        "25" { "Selected: Logon/logoff scripts" }
        "26" { "Selected: Disable Microsoft Store" }

        # File & Folder
        "27" { "Selected: RBAC model" }
        "28" { "Selected: Least privilege NTFS" }
        "29" { "Selected: Folder ACL inheritance" }
        "30" { "Selected: File access auditing" }

        default { "Invalid selection" }
    }
}

###############################################
# MAIN LOOP
###############################################
while ($true) {

    Show-MainMenu
    $mainChoice = Read-Host "Enter choice"

    switch ($mainChoice.ToUpper()) {

        "1" {
            while ($true) {
                Show-ComputerConfigMenu
                $sub = Read-Host "Select item"
                if ($sub.ToUpper() -eq "B") { break }

                $result = Process-Selection $sub
                Write-Host "`n$result`n" -ForegroundColor Yellow
                Pause
            }
        }

        "2" {
            while ($true) {
                Show-UserConfigMenu
                $sub = Read-Host "Select item"
                if ($sub.ToUpper() -eq "B") { break }

                $result = Process-Selection $sub
                Write-Host "`n$result`n" -ForegroundColor Yellow
                Pause
            }
        }

        "3" {
            while ($true) {
                Show-FileFolderMenu
                $sub = Read-Host "Select item"
                if ($sub.ToUpper() -eq "B") { break }

                $result = Process-Selection $sub
                Write-Host "`n$result`n" -ForegroundColor Yellow
                Pause
            }
        }

        "Q" { return }
        "q" { return }

        default {
            Write-Host "Invalid selection." -ForegroundColor Red
            Pause
        }
    }
}
