param()

<#
.SYNOPSIS
    Hardens built-in accounts such as Administrator and Guest.

.DESCRIPTION
    - Disable Guest
    - Rename Administrator (optional)
    - Optionally disable Administrator

    Equivalent to:
    Local Security Policy ->
        Security Settings ->
            Local Policies ->
                Security Options
#>

$NewAdminName = "LocalAdminRenamed"   # Change as needed
$DisableAdministrator = $false        # Set to $true if you want to disable it

Write-Host "Disabling Guest account..." -ForegroundColor Cyan
Disable-LocalUser -Name "Guest" -ErrorAction SilentlyContinue

Write-Host "Renaming built-in Administrator account..." -ForegroundColor Cyan
Rename-LocalUser -Name "Administrator" -NewName $NewAdminName -ErrorAction SilentlyContinue

if ($DisableAdministrator -eq $true) {
    Write-Host "Disabling built-in Administrator account..." -ForegroundColor Red
    Disable-LocalUser -Name $NewAdminName -ErrorAction SilentlyContinue
}

Write-Host "Built-in accounts hardened successfully!" -ForegroundColor Green
