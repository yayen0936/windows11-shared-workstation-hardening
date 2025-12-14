param()

<#
.SYNOPSIS
    Restricts access to Control Panel and the Settings app for all standard users.

.DESCRIPTION
    Locks down Control Panel and Settings by applying the HKCU-equivalent
    registry policy to every standard (non-administrator) local user.
    Must be run as Administrator.
#>

# --------------------------------------------------
# Pre-check: Must run as Administrator
# --------------------------------------------------
$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

Write-Host "[*] Applying Control Panel restriction to all standard users..." -ForegroundColor Cyan

# --------------------------------------------------
# Enumerate standard local users
# --------------------------------------------------
$StandardUsers = Get-LocalUser | Where-Object {
    $_.Enabled -eq $true -and
    $_.Name -notin @(
        "Administrator",
        "Guest",
        "DefaultAccount",
        "WDAGUtilityAccount"
    ) -and
    -not (Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue |
          Where-Object { $_.Name -like "*\$($_.Name)" })
}

foreach ($User in $StandardUsers) {

    $SID = $User.SID.Value
    $Path = "Registry::HKEY_USERS\$SID\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

    Write-Host "  -> Processing user: $($User.Name)" -ForegroundColor Yellow

    # Ensure user hive is loaded
    if (-not (Test-Path "Registry::HKEY_USERS\$SID")) {
        Write-Host "     [!] User has not logged in yet. Skipping." -ForegroundColor DarkYellow
        continue
    }

    # Create key if needed
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }

    # Disable Control Panel + Settings
    New-ItemProperty `
        -Path $Path `
        -Name "NoControlPanel" `
        -PropertyType DWORD `
        -Value 1 `
        -Force | Out-Null

    Write-Host "Control Panel restricted for $($User.Name)" -ForegroundColor Green
}

Write-Host "Control Panel and Settings access restricted for all standard users." -ForegroundColor Green