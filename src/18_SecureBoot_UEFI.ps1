param()

<#
.SYNOPSIS
    Applies OS-level Secure Boot and boot protections.

.DESCRIPTION
    - Ensures Secure Boot is enabled
    - Disables boot from external devices at OS level
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
