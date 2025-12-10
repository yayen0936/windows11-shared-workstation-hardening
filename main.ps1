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
    Write-Host "        Computer Configuration" -ForegroundColor Green
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
    Write-Host "            User Configuration" -ForegroundColor Green
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
    Write-Host "          File and Folder Structure" -ForegroundColor Green
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

        # COMPUTER CONFIG (1)
        "1" {
            . "$PSScriptRoot\src\1_Set-StrongLocalPasswordPolicy.ps1"
            return "Applied: Strong local password policy"
        }

        # Other items not yet implemented
        "2"  { return "Selected: Account lockout policy (not implemented yet)" }
        "3"  { return "Selected: Minimize local Administrators group" }
        "4"  { return "Selected: Harden built-in accounts" }
        "5"  { return "Selected: Secure logon options" }
        "6"  { return "Selected: UAC hardening" }
        "7"  { return "Selected: Automatic Windows patching" }
        "8"  { return "Selected: Endpoint protection" }
        "9"  { return "Selected: SmartScreen protection" }
        "10" { return "Selected: Windows Firewall baseline" }
        "11" { return "Selected: Secure remote access" }
        "12" { return "Selected: BitLocker encryption" }
        "13" { return "Selected: USB control" }
        "14" { return "Selected: Disable unnecessary services" }
        "15" { return "Selected: Disable AutoRun/AutoPlay" }
        "16" { return "Selected: Audit policy & logs" }
        "17" { return "Selected: Application control" }
        "18" { return "Selected: BIOS/UEFI boot security" }

        # USER CONFIG
        "19" { return "Selected: Restrict Control Panel" }
        "20" { return "Selected: Lock Start menu/taskbar" }
        "21" { return "Selected: Block system tools" }
        "22" { return "Selected: Screen saver & idle timeout" }
        "23" { return "Selected: Restrict drive access" }
        "24" { return "Selected: Browser hardening" }
        "25" { return "Selected: Logon/logoff scripts" }
        "26" { return "Selected: Disable Microsoft Store" }

        # FILE & FOLDER STRUCTURE
        "27" { return "Selected: RBAC access model" }
        "28" { return "Selected: Least privilege NTFS" }
        "29" { return "Selected: Controlled folder inheritance" }
        "30" { return "Selected: File access auditing" }

        default { return "Invalid selection" }
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
        default {
            Write-Host "Invalid selection." -ForegroundColor Red
            Pause
        }
    }
}
