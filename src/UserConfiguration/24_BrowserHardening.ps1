param()

<#
.SYNOPSIS
    Applies Microsoft Edge browser hardening for all standard users.

.DESCRIPTION
    Enforces per-user (HKCU-equivalent) Microsoft Edge policies by writing
    directly to each standard user's registry hive (HKEY_USERS\<SID>):
      - Enforced homepage
      - Mandatory SmartScreen
      - Blocked extension installation (explicit deny-all)
    Must be run as Administrator.
#>

# --------------------------------------------------
# Require Administrator
# --------------------------------------------------
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

Write-Host "[*] Applying Microsoft Edge browser hardening..." -ForegroundColor Cyan

# --------------------------------------------------
# Identify local Administrators
# --------------------------------------------------
$Admins = Get-LocalGroupMember Administrators -ErrorAction SilentlyContinue |
          ForEach-Object { $_.Name }

# --------------------------------------------------
# Enumerate standard users
# --------------------------------------------------
$StandardUsers = Get-LocalUser | Where-Object {
    $_.Enabled -and
    $_.Name -notin @(
        "Administrator",
        "Guest",
        "DefaultAccount",
        "WDAGUtilityAccount"
    ) -and
    ($Admins -notcontains "$env:COMPUTERNAME\$($_.Name)")
}

foreach ($User in $StandardUsers) {

    $SID = $User.SID.Value
    $UserHive = "Registry::HKEY_USERS\$SID"

    # User must have logged in at least once
    if (-not (Test-Path $UserHive)) {
        continue
    }

    # --------------------------------------------------
    # Edge per-user policy path (HKCU equivalent)
    # --------------------------------------------------
    $EdgePath = "$UserHive\Software\Policies\Microsoft\Edge"
    if (-not (Test-Path $EdgePath)) {
        New-Item -Path $EdgePath -Force | Out-Null
    }

    # --------------------------------------------------
    # FIX: Remove invalid/unsupported ExtensionsEnabled policy (prevents edge://policy "Error")
    # --------------------------------------------------
    Remove-ItemProperty -Path $EdgePath -Name "ExtensionsEnabled" -ErrorAction SilentlyContinue

    # --------------------------------------------------
    # Homepage enforcement
    # --------------------------------------------------
    New-ItemProperty -Path $EdgePath -Name "HomepageLocation"     -PropertyType String -Value "https://www.google.com" -Force | Out-Null
    New-ItemProperty -Path $EdgePath -Name "RestoreOnStartup"     -PropertyType DWORD  -Value 4 -Force | Out-Null
    New-ItemProperty -Path $EdgePath -Name "RestoreOnStartupURLs" -PropertyType MultiString -Value @("https://www.google.com") -Force | Out-Null

    # --------------------------------------------------
    # SmartScreen enforcement
    # --------------------------------------------------
    New-ItemProperty -Path $EdgePath -Name "SmartScreenEnabled"               -PropertyType DWORD -Value 1 -Force | Out-Null
    New-ItemProperty -Path $EdgePath -Name "PreventSmartScreenPromptOverride" -PropertyType DWORD -Value 1 -Force | Out-Null

    # --------------------------------------------------
    # Extension restriction (FIXED - supported policy format)
    # Edge uses:
    #   HKCU\Software\Policies\Microsoft\Edge\ExtensionInstallBlocklist
    #     "1"="*"
    # --------------------------------------------------
    $BlocklistPath = Join-Path $EdgePath "ExtensionInstallBlocklist"
    if (-not (Test-Path $BlocklistPath)) {
        New-Item -Path $BlocklistPath -Force | Out-Null
    }

    # Ensure deny-all entry exists
    New-ItemProperty -Path $BlocklistPath -Name "1" -PropertyType String -Value "*" -Force | Out-Null

    # Optional: remove any allowlist key so nothing is explicitly allowed
    $AllowlistPath = Join-Path $EdgePath "ExtensionInstallAllowlist"
    if (Test-Path $AllowlistPath) {
        Remove-Item -Path $AllowlistPath -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "Microsoft Edge browser hardening applied to all standard users." -ForegroundColor Green
Write-Host "Users must close and reopen Microsoft Edge (or sign out/in) for policies to take effect." -ForegroundColor DarkCyan