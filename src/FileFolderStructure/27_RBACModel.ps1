param()

<#
.SYNOPSIS
    Implements a Role-Based Access Control (RBAC) model using local groups.

.DESCRIPTION
    Creates local role groups (e.g., Data_HR_RW, Data_HR_RO).
    Users are assigned to groups, NOT directly to folder ACLs.

    This is the correct foundation for FS2–FS4.
#>

# -------------------------
# CONFIGURE RBAC GROUPS HERE
# -------------------------
$Groups = @(
    "Data_HR_RW",
    "Data_HR_RO",
    "Data_Finance_RW",
    "Data_Finance_RO",
    "Data_IT_Admins"
)

foreach ($group in $Groups) {
    if (-not (Get-LocalGroup -Name $group -ErrorAction SilentlyContinue)) {
        Write-Host "Creating local group: $group"
        New-LocalGroup -Name $group -Description "RBAC Role Group"
    }
    else {
        Write-Host "Group already exists: $group"
    }
}

Write-Host "RBAC role groups successfully created." -ForegroundColor Green
