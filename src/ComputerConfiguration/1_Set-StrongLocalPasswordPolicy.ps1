<#
.SYNOPSIS
    Configures strong password policy identical to:
    Computer Configuration -> Windows Settings -> Security Settings ->
    Account Policies -> Password Policy
#>

# ----------------------------------------
# Define password policy settings
# ----------------------------------------
$PasswordPolicy = @{
    MinimumPasswordLength  = 12
    PasswordHistorySize    = 24
    MaximumPasswordAge     = 90
    MinimumPasswordAge     = 1
    PasswordComplexity     = 1
    ClearTextPassword      = 0
}

# ----------------------------------------
# Paths
# ----------------------------------------
$LogPath = "C:\Users\yayen\Documents\windows11-shared-workstation-hardening\logs"
$InfFile = Join-Path $LogPath "PasswordPolicy.inf"

# ----------------------------------------
# Ensure log folder exists
# ----------------------------------------
if (-not (Test-Path $LogPath)) {
    New-Item -Path $LogPath -ItemType Directory | Out-Null
}

# ----------------------------------------
# Grant SYSTEM read/write access (required for secedit)
# ----------------------------------------
icacls $LogPath /grant "SYSTEM:(OI)(CI)(F)" /T | Out-Null

# ----------------------------------------
# Create .INF template content
# ----------------------------------------
$content = @"
[Unicode]
Unicode=yes

[System Access]
MinimumPasswordLength = $($PasswordPolicy.MinimumPasswordLength)
PasswordHistorySize   = $($PasswordPolicy.PasswordHistorySize)
MaximumPasswordAge    = $($PasswordPolicy.MaximumPasswordAge)
MinimumPasswordAge    = $($PasswordPolicy.MinimumPasswordAge)
PasswordComplexity    = $($PasswordPolicy.PasswordComplexity)
ClearTextPassword     = $($PasswordPolicy.ClearTextPassword)
RequireLogonToChangePassword = 0
LockoutBadCount = 0

[Version]
signature = "\$CHICAGO\$"
Revision = 1
"@

# ----------------------------------------
# Write INF as ANSI (no BOM)
# ----------------------------------------
[System.IO.File]::WriteAllText($InfFile, $content, [System.Text.Encoding]::GetEncoding(1252))

Write-Host "Security template created at: $InfFile" -ForegroundColor Yellow

# ----------------------------------------
# Apply using secedit
# ----------------------------------------
Write-Host "`nApplying password policy..." -ForegroundColor Cyan

secedit.exe /configure `
    /db "$env:WINDIR\Security\Database\local.sdb" `
    /cfg $InfFile `
    /areas SECURITYPOLICY

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nPassword policy applied successfully!" -ForegroundColor Green
} else {
    Write-Host "`nFailed. Exit code: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "Check scesrv.log under C:\Windows\Security\Logs" -ForegroundColor Yellow
}

Write-Host "`nDone."