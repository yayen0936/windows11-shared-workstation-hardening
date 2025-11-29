# -----------------------------
# Pre-Checks
# -----------------------------
function Test-RunAsAdmin {
    $principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
    )

    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Write-Error "This script must be run as Administrator. Right-click PowerShell and choose 'Run as administrator'."
        exit 1
    }
}

function Test-ExecutionPolicy {
    try {
        $currentUserPolicy = Get-ExecutionPolicy -Scope CurrentUser -ErrorAction SilentlyContinue
        if ($currentUserPolicy -ne 'RemoteSigned') {
            Write-Host "Setting execution policy for CurrentUser to 'RemoteSigned'..." -ForegroundColor Yellow
            Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force -ErrorAction Stop
            Write-Host "Execution policy for CurrentUser is now 'RemoteSigned'." -ForegroundColor Green
        }
        else {
            Write-Host "Execution policy for CurrentUser is already 'RemoteSigned'." -ForegroundColor Green
        }
    }
    catch {
        Write-Error "Failed to set execution policy. Cannot continue safely. Error: $($_.Exception.Message)"
        exit 1
    }
}

# -----------------------------
# Menu function
# -----------------------------
function Show-MainMenu {
    Clear-Host
    Write-Host "Windows 11 Shared Workstation Hardening" -ForegroundColor Cyan
    Write-Host "-------------------------------------------------"
    Write-Host "1) Computer Configuration Policies"
    Write-Host "2) User Configuration Policies"
    Write-Host "3) File System & Data Access Controls"
    Write-Host "0) Exit"
    Write-Host ""
}

# -----------------------------
# Sub-Menus
# -----------------------------
function Invoke-ComputerConfigurationPolicies {
    Clear-Host
    Write-Host "[Computer Configuration Policies]" -ForegroundColor Green
    Write-Host ""
    Read-Host "Press ENTER to return to the main menu" | Out-Null
}

function Invoke-UserConfigurationPolicies {
    Clear-Host
    Write-Host "[User Configuration Policies]" -ForegroundColor Green
    Write-Host ""
    Read-Host "Press ENTER to return to the main menu" | Out-Null
}

function Invoke-FileSystemDataAccessControls {
    Clear-Host
    Write-Host "[File System & Data Access Controls]" -ForegroundColor Green
    Write-Host ""
    Read-Host "Press ENTER to return to the main menu" | Out-Null
}

# -----------------------------
# Main loop
# -----------------------------

# Run Pre-Checks
Test-RunAsAdmin
Test-ExecutionPolicy

# Menu Display
do {
    Show-MainMenu
    $choice = Read-Host "Select an option"

    switch ($choice) {
        '1' { Invoke-ComputerConfigurationPolicies }
        '2' { Invoke-UserConfigurationPolicies }
        '3' { Invoke-FileSystemDataAccessControls }
        '0' { Write-Host "Exiting..." -ForegroundColor Yellow }
        default {
            Write-Host "Invalid selection. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
while ($choice -ne '0')