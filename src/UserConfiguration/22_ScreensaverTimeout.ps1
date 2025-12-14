param()

<#
.SYNOPSIS
    Enforces a password-protected screen saver with a timeout
    for all standard users.

.DESCRIPTION
    Applies the HKCU-equivalent screen saver policy by writing
    directly to each standard user's registry hive (HKEY_USERS\<SID>).
    - Screen saver enabled
    - Password required on resume
    - Timeout set to 900 seconds (15 minutes)
    Must be run as Administrator.
#>

# --------------------------------------------------
# Pre-check: Must run as Administrator
# --------------------------------------------------
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

Write-Host "[*] Applying screen saver timeout to all standard users..." -ForegroundColor Cyan

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

    Write-Host "  -> Processing user: $($User.Name)" -ForegroundColor Yellow

    $SID = $User.SID.Value
    $UserHive = "Registry::HKEY_USERS\$SID"

    # Ensure user hive is loaded (user must have logged in at least once)
    if (-not (Test-Path $UserHive)) {
        Write-Host "     [!] User has not logged in yet. Skipping." -ForegroundColor DarkYellow
        continue
    }

    # --------------------------------------------------
    # Screen saver policy path (HKCU equivalent)
    # --------------------------------------------------
    $CP = "$UserHive\Software\Policies\Microsoft\Windows\Control Panel\Desktop"

    if (-not (Test-Path $CP)) {
        New-Item -Path $CP -Force | Out-Null
    }

    # --------------------------------------------------
    # Apply screen saver policies
    # --------------------------------------------------
    New-ItemProperty -Path $CP -Name "ScreenSaveActive"      -PropertyType String -Value "1"   -Force | Out-Null
    New-ItemProperty -Path $CP -Name "ScreenSaverIsSecure"  -PropertyType String -Value "1"   -Force | Out-Null
    New-ItemProperty -Path $CP -Name "ScreenSaveTimeOut"    -PropertyType String -Value "900" -Force | Out-Null

    Write-Host "Screen saver enforced for $($User.Name)" -ForegroundColor Green
}

Write-Host "Screen saver lock and 15-minute idle timeout applied to all standard users." -ForegroundColor Green
Write-Host "Note: Users must sign out and sign back in for the policy to fully take effect." -ForegroundColor DarkCyan
