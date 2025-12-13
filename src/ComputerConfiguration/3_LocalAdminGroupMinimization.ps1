param()

<#
.SYNOPSIS
    Minimizes membership of the local Administrators group.

.DESCRIPTION
    Ensures that only explicitly approved administrative accounts remain
    members of the local Administrators group, enforcing least privilege
    on a Windows 11 shared workstation.
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
# Configure Approved Admin Accounts
# ===============================
# Administrator is approved here, but hardened/disabled in CC4
$ApprovedAdmins = @(
    "Administrator",
    "bbojangles"
)

$ComputerName = $env:COMPUTERNAME
$ApprovedAdminFQNs = $ApprovedAdmins | ForEach-Object { "$ComputerName\$_" }

# ===============================
# Remove Unauthorized Administrators
# ===============================
$currentMembers = Get-LocalGroupMember -Group "Administrators"

foreach ($member in $currentMembers) {

    if ($ApprovedAdminFQNs -notcontains $member.Name) {
        Write-Host "Removing unauthorized administrator: $($member.Name)" `
            -ForegroundColor Yellow

        Remove-LocalGroupMember `
            -Group "Administrators" `
            -Member $member.Name `
            -ErrorAction SilentlyContinue
    }
}

# ===============================
# Ensure Approved Admins Are Present
# ===============================
foreach ($adminFQN in $ApprovedAdminFQNs) {

    if (-not (Get-LocalGroupMember -Group "Administrators" |
        Where-Object { $_.Name -eq $adminFQN })) {

        try {
            Add-LocalGroupMember -Group "Administrators" -Member $adminFQN -ErrorAction Stop
            Write-Host "Ensured authorized administrator: $adminFQN" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to ensure admin membership for: $adminFQN"
        }
    }
}

# ===============================
# Post-check Verification
# ===============================
Write-Host ""
Write-Host "[*] Final Local Administrators Group Membership:" -ForegroundColor Cyan
Write-Host "------------------------------------------------"

Get-LocalGroupMember -Group "Administrators" |
    Select-Object Name, ObjectClass |
    ForEach-Object {
        Write-Host ("{0,-35} {1}" -f $_.Name, $_.ObjectClass)
    }

Write-Host "------------------------------------------------"
Write-Host "Local Administrators group minimized successfully." -ForegroundColor Green

exit 0
