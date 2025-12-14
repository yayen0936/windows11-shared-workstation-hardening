param()

<#
.SYNOPSIS
    Restricts access to drives in File Explorer for all standard users.

.DESCRIPTION
    Applies the HKCU-equivalent Explorer policy by writing directly
    to each standard user's registry hive (HKEY_USERS\<SID>).
    - Hides C: drive using bitmask value 4
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

Write-Host "[*] Applying drive visibility restrictions to all standard users..." -ForegroundColor Cyan

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

    # Ensure user hive is loaded
    if (-not (Test-Path $UserHive)) {
        Write-Host "     [!] User has not logged in yet. Skipping." -ForegroundColor DarkYellow
        continue
    }

    # --------------------------------------------------
    # Explorer policy path (HKCU equivalent)
    # --------------------------------------------------
    $Explorer = "$UserHive\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

    if (-not (Test-Path $Explorer)) {
        New-Item -Path $Explorer -Force | Out-Null
    }

    # --------------------------------------------------
    # Hide C: drive (bitmask 4)
    # --------------------------------------------------
    New-ItemProperty -Path $Explorer -Name "NoViewOnDrive"  -PropertyType DWORD -Value 4 -Force | Out-Null
    New-ItemProperty -Path $Explorer -Name "NoViewOnDrives" -PropertyType DWORD -Value 4 -Force | Out-Null

    Write-Host "C: drive hidden for $($User.Name)" -ForegroundColor Green
}

Write-Host "Drive visibility restrictions applied to all standard users." -ForegroundColor Green
Write-Host "Note: Users must sign out and sign back in (or restart Explorer) for changes to take effect." -ForegroundColor DarkCyan
