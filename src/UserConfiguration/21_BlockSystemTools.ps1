param()

<#
.SYNOPSIS
    Blocks system administration tools for all standard users.

.DESCRIPTION
    Applies HKCU-equivalent restrictions for:
    - Command Prompt
    - PowerShell (execution policy)
    - Registry Editor
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

Write-Host "[*] Blocking system tools for all standard users..." -ForegroundColor Cyan

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
    # Registry paths
    # --------------------------------------------------
    $SystemPolicy  = "$UserHive\Software\Microsoft\Windows\CurrentVersion\Policies\System"
    $CmdPolicy     = "$UserHive\Software\Policies\Microsoft\Windows\System"
    $ExplorerPolicy = "$UserHive\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    $DisallowRunKey = "$ExplorerPolicy\DisallowRun"
    $PsPolicy      = "$UserHive\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell"

    if (-not (Test-Path $SystemPolicy))  { New-Item -Path $SystemPolicy  -Force | Out-Null }
    if (-not (Test-Path $CmdPolicy))     { New-Item -Path $CmdPolicy     -Force | Out-Null }
    if (-not (Test-Path $ExplorerPolicy)){ New-Item -Path $ExplorerPolicy -Force | Out-Null }
    if (-not (Test-Path $DisallowRunKey)){ New-Item -Path $DisallowRunKey -Force | Out-Null }
    if (-not (Test-Path $PsPolicy))      { New-Item -Path $PsPolicy      -Force | Out-Null }

    # --------------------------------------------------
    # Block CMD (correct policy location)
    # DisableCMD:
    # 1 = Disable batch files
    # 2 = Disable CMD completely
    # --------------------------------------------------
    New-ItemProperty -Path $CmdPolicy -Name "DisableCMD" -PropertyType DWORD -Value 2 -Force | Out-Null

    # --------------------------------------------------
    # Block Registry Editor
    # --------------------------------------------------
    New-ItemProperty -Path $SystemPolicy -Name "DisableRegistryTools" -PropertyType DWORD -Value 1 -Force | Out-Null

    # --------------------------------------------------
    # Block PowerShell launch via "Don't run specified Windows applications"
    # (also blocks cmd/regedit here for consistency)
    # --------------------------------------------------
    New-ItemProperty -Path $ExplorerPolicy -Name "DisallowRun" -PropertyType DWORD -Value 1 -Force | Out-Null
    New-ItemProperty -Path $DisallowRunKey -Name "1" -PropertyType String -Value "cmd.exe" -Force | Out-Null
    New-ItemProperty -Path $DisallowRunKey -Name "2" -PropertyType String -Value "powershell.exe" -Force | Out-Null
    New-ItemProperty -Path $DisallowRunKey -Name "3" -PropertyType String -Value "pwsh.exe" -Force | Out-Null
    New-ItemProperty -Path $DisallowRunKey -Name "4" -PropertyType String -Value "regedit.exe" -Force | Out-Null

    # --------------------------------------------------
    # Block PowerShell (per-user execution policy)
    # --------------------------------------------------
    New-ItemProperty -Path $PsPolicy -Name "ExecutionPolicy" -PropertyType String -Value "Restricted" -Force | Out-Null

    Write-Host "System tools blocked for $($User.Name)" -ForegroundColor Green
}

Write-Host "System tools (CMD, PowerShell, regedit) blocked for all standard users." -ForegroundColor Green
Write-Host "Note: Users may need to sign out/in (or restart Explorer) for DisallowRun to fully take effect." -ForegroundColor DarkCyan