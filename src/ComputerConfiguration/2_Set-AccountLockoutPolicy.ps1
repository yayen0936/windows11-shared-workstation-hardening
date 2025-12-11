param()

<#
.SYNOPSIS
    Configures the Account Lockout Policy identical to:
    Computer Configuration -> Windows Settings -> Security Settings ->
    Account Policies -> Account Lockout Policy

.DESCRIPTION
    Applies the following settings:
        - Account lockout threshold
        - Account lockout duration
        - Reset account lockout counter after

    These settings take effect immediately and apply to all local accounts.
#>

# ----------------------------------------
# CONFIGURABLE SECURITY SETTINGS (EDIT HERE)
# ----------------------------------------
$LockoutPolicy = @{
    LockoutBadCount       = 5      # Lock out after 5 failed logon attempts
    LockoutDuration       = 15     # Duration (in minutes) the account remains locked
    ResetLockoutCount     = 15     # Time (in minutes) to reset failed logon counter
}

# ----------------------------------------
# PATHS
# ----------------------------------------
$LogPath = "$PSScriptRoot\..\logs"
$InfFile = Join-Path $LogPath "AccountLockoutPolicy.inf"

# Ensure logs folder exists
if (-not (Test-Path $LogPath)) {
    New-Item -Path $LogPath -ItemType Directory | Out-Null
}

# Ensure SYSTEM has access (required for secedit)
icacls $LogPath /grant "SYSTEM:(OI)(CI)(F)" /T | Out-Null

# ----------------------------------------
# CREATE SECURITY TEMPLATE (.INF)
# ----------------------------------------
$content = @"
[Unicode]
Unicode=yes

[System Access]
LockoutBadCount          = $($LockoutPolicy.LockoutBadCount)
LockoutDuration          = $($LockoutPolicy.LockoutDuration)
ResetLockoutCount        = $($LockoutPolicy.ResetLockoutCount)

[Version]
signature = "\$CHICAGO\$"
Revision = 1
"@

# Write as ANSI (no BOM)
[System.IO.File]::WriteAllText($InfFile, $content, [System.Text.Encoding]::GetEncoding(1252))

Write-Host "Account Lockout Policy template created at: $InfFile" -ForegroundColor Yellow

# ----------------------------------------
# APPLY POLICY USING SECEDIT
# ----------------------------------------
Write-Host "`nApplying Account Lockout Policy..." -ForegroundColor Cyan

secedit.exe /configure `
    /db "$env:WINDIR\Security\Database\local.sdb" `
    /cfg $InfFile `
    /areas SECURITYPOLICY

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nAccount Lockout Policy applied successfully!" -ForegroundColor Green
} else {
    Write-Host "`nFAILED. Exit code: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "Check C:\Windows\Security\Logs\scesrv.log for details." -ForegroundColor Yellow
}

Write-Host "`nDone."
