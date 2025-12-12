<#
.SYNOPSIS
    Enforces a strong local password policy on Windows 11 shared workstations.

.DESCRIPTION
    Applies hardened local account password policy using supported Windows mechanisms.

    Covers:
    - Minimum password length
    - Password history
    - Maximum / minimum password age
    - Password complexity
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
# Password Policy Parameters
# ===============================
$MinLength      = 12
$History        = 24
$MaxAgeDays     = 90
$MinAgeDays     = 1
$Complexity     = 1   # 1 = Enabled

# ===============================
# Logging
# ===============================
$LogPath = Join-Path $PSScriptRoot "logs"
$LogFile = Join-Path $LogPath "PasswordPolicy.log"

if (-not (Test-Path $LogPath)) {
    New-Item -Path $LogPath -ItemType Directory | Out-Null
}

Start-Transcript -Path $LogFile -Append | Out-Null

Write-Host "[*] Applying strong local password policy..." -ForegroundColor Cyan

# ===============================
# Enforce Password Policy
# ===============================
try {
    # Length, history, age
    net accounts `
        /minpwlen:$MinLength `
        /uniquepw:$History `
        /maxpwage:$MaxAgeDays `
        /minpwage:$MinAgeDays | Out-Null

    Write-Host "[+] Password length, history, and age enforced." -ForegroundColor Green
}
catch {
    Write-Error "Failed to apply password age/length policy."
    Stop-Transcript | Out-Null
    exit 1
}

# ===============================
# Enforce Password Complexity
# ===============================
try {
    reg add `
        "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" `
        /v PasswordComplexity `
        /t REG_DWORD `
        /d $Complexity `
        /f | Out-Null

    Write-Host "[+] Password complexity enforced." -ForegroundColor Green
}
catch {
    Write-Error "Failed to enforce password complexity."
    Stop-Transcript | Out-Null
    exit 1
}

# ===============================
# Post-check Verification
# ===============================
Write-Host "`n[*] Current Local Password Policy:" -ForegroundColor Cyan
net accounts

$ComplexityStatus = Get-ItemProperty `
    "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" `
    -Name PasswordComplexity

Write-Host "`nPassword Complexity Enabled: $($ComplexityStatus.PasswordComplexity)" `
    -ForegroundColor Yellow

# ===============================
# Completion
# ===============================
Write-Host "Strong local password policy applied successfully." -ForegroundColor Green

Stop-Transcript | Out-Null
exit 0
