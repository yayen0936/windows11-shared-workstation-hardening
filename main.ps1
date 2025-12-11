###############################################
# MAIN MENU
###############################################
function Show-MainMenu {
    Clear-Host
    Write-Host "============================================="
    Write-Host "        Workstation Security Hardening" -ForegroundColor Cyan
    Write-Host "============================================="
    Write-Host ""
    Write-Host "1)  Computer Configuration"
    Write-Host "2)  User Configuration"
    Write-Host "3)  File and Folder Structure"
    Write-Host ""
    Write-Host "Q)  Quit"
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
    Write-Host "  3  - Local admin group minimization"
    Write-Host "  4  - Harden built-in accounts"
    Write-Host "  5  - Secure logon options"
    Write-Host "  6  - Strong UAC configuration"
    Write-Host "  7  - Enforce automatic OS patching"
    Write-Host "  8  - Endpoint protection (Defender)"
    Write-Host "  9  - SmartScreen & reputation protection"
    Write-Host "  10 - Windows Firewall baseline"
    Write-Host "  11 - Secure remote access (RDP/WinRM)"
    Write-Host "  12 - BitLocker disk encryption"
    Write-Host "  13 - USB / device control"
    Write-Host "  14 - Disable unnecessary services"
    Write-Host "  15 - Disable AutoRun/AutoPlay"
    Write-Host "  16 - Advanced audit policy"
    Write-Host "  17 - Application control (AppLocker)"
    Write-Host "  18 - Secure Boot / UEFI configuration"
    Write-Host ""
    Write-Host "B)  Back"
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
    Write-Host "  19 - Restrict Control Panel & Settings"
    Write-Host "  20 - Lock down Start menu & taskbar"
    Write-Host "  21 - Block system tools (cmd, PowerShell, regedit)"
    Write-Host "  22 - Screen-saver lock & idle timeout"
    Write-Host "  23 - Restrict drive visibility"
    Write-Host "  24 - Browser hardening"
    Write-Host "  25 - Logon/logoff hygiene scripts"
    Write-Host "  26 - Disable Microsoft Store"
    Write-Host ""
    Write-Host "B)  Back"
    Write-Host ""
}

###############################################
# FILE & FOLDER STRUCTURE MENU
###############################################
function Show-FileFolderMenu {
    Clear-Host
    Write-Host "============================================="
    Write-Host "        File & Folder Structure" -ForegroundColor Green
    Write-Host "============================================="
    Write-Host ""
    Write-Host "  27 - RBAC (role-based group model)"
    Write-Host "  28 - Break inheritance & remove inherited ACLs"
    Write-Host "  29 - Apply least-privilege NTFS baseline"
    Write-Host "  30 - File access auditing"
    Write-Host ""
    Write-Host "B)  Back"
    Write-Host ""
}

###############################################
# LOAD AND EXECUTE SELECTED SCRIPT
###############################################
function Run-Module {
    param(
        [string]$Category,
        [string]$ScriptName
    )

    $FullPath = "$PSScriptRoot\src\$Category\$ScriptName"

    if (Test-Path $FullPath) {
        . $FullPath
        return "Executed: $Category\$ScriptName"
    }
    else {
        return "Module not found: $FullPath"
    }
}

###############################################
# PROCESS COMPUTER CONFIGURATION SELECTION
###############################################
function Process-CC {
    param([string]$choice)

    switch ($choice) {

        "1"  { Run-Module "ComputerConfiguration" "1_Set-StrongLocalPasswordPolicy.ps1" }
        "2"  { Run-Module "ComputerConfiguration" "2_Set-AccountLockoutPolicy.ps1" }
        "3"  { Run-Module "ComputerConfiguration" "3_LocalAdminGroupMinimization.ps1" }
        "4"  { Run-Module "ComputerConfiguration" "4_HardenBuiltInAccounts.ps1" }
        "5"  { Run-Module "ComputerConfiguration" "5_SecureLogonOptions.ps1" }
        "6"  { Run-Module "ComputerConfiguration" "6_StrongUACConfiguration.ps1" }
        "7"  { Run-Module "ComputerConfiguration" "7_EnforceAutomaticOSPatching.ps1" }
        "8"  { Run-Module "ComputerConfiguration" "8_EndpointProtection.ps1" }
        "9"  { Run-Module "ComputerConfiguration" "9_SmartScreenProtection.ps1" }
        "10" { Run-Module "ComputerConfiguration" "10_WindowsFirewallBaseline.ps1" }
        "11" { Run-Module "ComputerConfiguration" "11_SecureRemoteAccess.ps1" }
        "12" { Run-Module "ComputerConfiguration" "12_EnableBitLocker.ps1" }
        "13" { Run-Module "ComputerConfiguration" "13_USBDeviceControl.ps1" }
        "14" { Run-Module "ComputerConfiguration" "14_DisableUnnecessaryServices.ps1" }
        "15" { Run-Module "ComputerConfiguration" "15_DisableAutoRunAutoPlay.ps1" }
        "16" { Run-Module "ComputerConfiguration" "16_AdvancedAuditPolicy.ps1" }
        "17" { Run-Module "ComputerConfiguration" "17_AppLockerBaseline.ps1" }
        "18" { Run-Module "ComputerConfiguration" "18_SecureBoot_UEFI.ps1" }

        default { "Invalid selection" }
    }
}

###############################################
# PROCESS USER CONFIGURATION SELECTION
###############################################
function Process-UC {
    param([string]$choice)

    switch ($choice) {

        "19" { Run-Module "UserConfiguration" "19_RestrictControlPanel.ps1" }
        "20" { Run-Module "UserConfiguration" "20_LockStartMenu.ps1" }
        "21" { Run-Module "UserConfiguration" "21_BlockSystemTools.ps1" }
        "22" { Run-Module "UserConfiguration" "22_ScreensaverTimeout.ps1" }
        "23" { Run-Module "UserConfiguration" "23_RestrictDriveVisibility.ps1" }
        "24" { Run-Module "UserConfiguration" "24_BrowserHardening.ps1" }
        "25" { Run-Module "UserConfiguration" "25_LogonLogoffScripts.ps1" }
        "26" { Run-Module "UserConfiguration" "26_DisableMicrosoftStore.ps1" }

        default { "Invalid selection" }
    }
}

###############################################
# PROCESS FILE / FOLDER STRUCTURE SELECTION
###############################################
function Process-FS {
    param([string]$choice)

    switch ($choice) {

        "27" { Run-Module "FileFolderStructure" "27_RBACModel.ps1" }
        "28" { Run-Module "FileFolderStructure" "28_FolderInheritanceACL.ps1" }
        "29" { Run-Module "FileFolderStructure" "29_LeastPrivilegeNTFS.ps1" }
        "30" { Run-Module "FileFolderStructure" "30_FileAccessAuditing.ps1" }

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

                $result = Process-CC $sub
                Write-Host "`n$result`n" -ForegroundColor Yellow
                Pause
            }
        }

        "2" {
            while ($true) {
                Show-UserConfigMenu
                $sub = Read-Host "Select item"
                if ($sub.ToUpper() -eq "B") { break }

                $result = Process-UC $sub
                Write-Host "`n$result`n" -ForegroundColor Yellow
                Pause
            }
        }

        "3" {
            while ($true) {
                Show-FileFolderMenu
                $sub = Read-Host "Select item"
                if ($sub.ToUpper() -eq "B") { break }

                $result = Process-FS $sub
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
