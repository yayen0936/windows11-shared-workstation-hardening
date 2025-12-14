param()

<#
.SYNOPSIS
    Applies OS-level boot configuration hardening.

.DESCRIPTION
    Verifies whether Secure Boot is enabled via UEFI and applies Windows boot
    configuration settings that reduce interactive boot options (e.g., hiding
    the boot menu) to make unauthorized boot-time tampering more difficult.
    Note: Secure Boot enforcement and preventing boot from external media are
    primarily firmware (BIOS/UEFI) controls and must be configured manually
    outside the operating system.
#>

if ((Confirm-SecureBootUEFI) -eq $false) {
    Write-Host "WARNING: Secure Boot is disabled in firmware!" -ForegroundColor Red
} else {
    Write-Host "Secure Boot is enabled." -ForegroundColor Green
}

# Restrict boot to internal drive
bcdedit /set {globalsettings} bootux disabled | Out-Null
bcdedit /set {bootmgr} displaybootmenu no | Out-Null

Write-Host "OS-level boot restrictions applied. BIOS/UEFI changes must be done manually." -ForegroundColor Yellow
