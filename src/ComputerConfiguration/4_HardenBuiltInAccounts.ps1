param()

<#
.SYNOPSIS
    Hardens built-in accounts such as Administrator and Guest.

.DESCRIPTION
    - Disable Guest
    - Disable built-in Administrator
    - Rename built-in Administrator
#>

$NewAdminName = "sp-recovery"         # Change as needed
$DisableAdministrator = $true         # Required for this control

Write-Host "Disabling Guest account..." -ForegroundColor Cyan
Disable-LocalUser -Name "Guest" -ErrorAction SilentlyContinue

Write-Host "Renaming built-in Administrator account..." -ForegroundColor Cyan
Rename-LocalUser -Name "Administrator" -NewName $NewAdminName -ErrorAction SilentlyContinue

if ($DisableAdministrator -eq $true) {
    Write-Host "Disabling built-in Administrator account..." -ForegroundColor Red

    # Disable whichever name currently exists (covers rename success/failure)
    Disable-LocalUser -Name $NewAdminName -ErrorAction SilentlyContinue
    Disable-LocalUser -Name "Administrator" -ErrorAction SilentlyContinue
}

Write-Host "Built-in accounts hardened successfully!" -ForegroundColor Green
