param()

<#
.SYNOPSIS
    Restricts Start menu and taskbar customization for all standard users.

.DESCRIPTION
    Applies HKCU-equivalent Start menu and taskbar restrictions by writing
    directly to each standard user's registry hive (HKEY_USERS\<SID>).
    - Removes Run command
    - Hides administrative tools
    - Blocks Start menu and taskbar customization
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

Write-Host "[*] Applying Start menu lockdown to all standard users..." -ForegroundColor Cyan

# --------------------------------------------------
# Enumerate standard local users
# --------------------------------------------------
$Admins = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue |
          ForEach-Object { $_.Name }

$StandardUsers = Get-LocalUser | Where-Object {
    $_.Enabled -eq $true -and
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

    $SID  = $User.SID.Value
    $Path = "Registry::HKEY_USERS\$SID\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

    # Ensure user hive is loaded
    if (-not (Test-Path "Registry::HKEY_USERS\$SID")) {
        Write-Host "     [!] User has not logged in yet. Skipping." -ForegroundColor DarkYellow
        continue
    }

    # Create policy key if needed
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }

    # Apply Start menu and taskbar restrictions
    New-ItemProperty -Path $Path -Name "NoRun"             -PropertyType DWORD -Value 1 -Force | Out-Null
    New-ItemProperty -Path $Path -Name "NoSetTaskbar"      -PropertyType DWORD -Value 1 -Force | Out-Null
    New-ItemProperty -Path $Path -Name "StartMenuLogOff"   -PropertyType DWORD -Value 1 -Force | Out-Null
    New-ItemProperty -Path $Path -Name "NoChangeStartMenu" -PropertyType DWORD -Value 1 -Force | Out-Null
    New-ItemProperty -Path $Path -Name "NoCommonGroups"    -PropertyType DWORD -Value 1 -Force | Out-Null

    Write-Host "Start menu locked for $($User.Name)" -ForegroundColor Green
}

Write-Host "Start menu and taskbar lockdown applied to all standard users." -ForegroundColor Green