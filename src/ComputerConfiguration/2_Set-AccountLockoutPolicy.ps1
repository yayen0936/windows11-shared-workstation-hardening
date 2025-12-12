param()

<#
.SYNOPSIS
    Configures secure Account Lockout Policy settings on a Windows 11 shared workstation.

.DESCRIPTION
    Enforces security-recommended account lockout controls

    Configured settings:
    - Account lockout threshold
    - Account lockout duration
    - Reset account lockout counter after
    - Allow Administrator account lockout
#>

# ===============================
# Pre-check: Run as Administrator
# ===============================
$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# ===============================
# Security-Recommended Settings
# ===============================
$LockoutThreshold    = 5    # Invalid logon attempts
$LockoutDuration     = 15   # Minutes
$LockoutWindow       = 15   # Minutes
$AllowAdminLockout   = 1    # 1 = Enabled

# ===============================
# Apply Account Lockout Policy
# ===============================
Write-Host "[*] Applying Account Lockout Policy..." -ForegroundColor Cyan

net accounts `
    /lockoutthreshold:$LockoutThreshold `
    /lockoutduration:$LockoutDuration `
    /lockoutwindow:$LockoutWindow | Out-Null

# Enable Administrator account lockout
reg add `
    "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" `
    /v AllowAdminAccountLockout `
    /t REG_DWORD `
    /d $AllowAdminLockout `
    /f | Out-Null

# ===============================
# Post-check Verification
# ===============================
Write-Host ""
Write-Host "[*] Account Lockout Policy (Configured Settings)" -ForegroundColor Cyan
Write-Host "------------------------------------------------"

# Read values back
$netAccounts = (net accounts) -split "`r?`n"

$threshold = ($netAccounts | Where-Object { $_ -match "Lockout threshold" }) `
    -replace '.*:\s*', ''
$duration  = ($netAccounts | Where-Object { $_ -match "Lockout duration" }) `
    -replace '.*:\s*', ''
$window    = ($netAccounts | Where-Object { $_ -match "Lockout observation window" }) `
    -replace '.*:\s*', ''

$adminLockout = Get-ItemProperty `
    "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" `
    -Name AllowAdminAccountLockout `
    -ErrorAction SilentlyContinue

$adminLockoutStatus = if ($adminLockout.AllowAdminAccountLockout -eq 1) {
    "Enabled"
} else {
    "Disabled"
}

# Display exactly what Local Security Policy shows
Write-Host ("Account lockout duration                : {0}" -f $duration)
Write-Host ("Account lockout threshold               : {0}" -f $threshold)
Write-Host ("Allow Administrator account lockout     : {0}" -f $adminLockoutStatus)
Write-Host ("Reset account lockout counter after     : {0}" -f $window)

Write-Host "------------------------------------------------"
Write-Host "Account Lockout Policy applied successfully." -ForegroundColor Green

exit 0
