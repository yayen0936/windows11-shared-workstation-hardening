param()

<#
.SYNOPSIS
    Creates local RBAC groups and assigns users based on organizational roles.

.DESCRIPTION
    Uses the real user → role → local group mapping provided.
#>

# -------------------------
# DEFINE GROUPS
# -------------------------
$Groups = @(
    "Estimating_Design",
    "Finance_Administration",
    "Operations_Sales",
    "IT"
)

# -------------------------
# CREATE GROUPS IF MISSING
# -------------------------
foreach ($group in $Groups) {
    if (-not (Get-LocalGroup -Name $group -ErrorAction SilentlyContinue)) {
        Write-Host "Creating local group: $group"
        New-LocalGroup -Name $group -Description "RBAC Role Group" | Out-Null
    } else {
        Write-Host "Group already exists: $group"
    }
}

# -------------------------
# USER → ROLE → GROUP ASSIGNMENTS
# -------------------------

$Assignments = @(
    @{ User="mvance";       Group="Estimating_Design" }
    @{ User="crodriguez";   Group="Estimating_Design" }
    @{ User="bcarter";      Group="Estimating_Design" }
    @{ User="swilliams";    Group="Estimating_Design" }

    @{ User="dchen";        Group="Finance_Administration" }
    @{ User="psharma";      Group="Finance_Administration" }
    @{ User="ajenkins";     Group="Finance_Administration" }
    @{ User="epopa";        Group="Finance_Administration" }

    @{ User="frossi";       Group="Operations_Sales" }
    @{ User="sblythe";      Group="Operations_Sales" }
    @{ User="lmitchell";    Group="Operations_Sales" }
    @{ User="tgreen";       Group="Operations_Sales" }

    @{ User="bbojangles";   Group="IT" }
)

foreach ($item in $Assignments) {
    try {
        Add-LocalGroupMember -Group $item.Group -Member $item.User -ErrorAction Stop
        Write-Host "Added $($item.User) → $($item.Group)"
    }
    catch {
        Write-Host "Failed to add $($item.User) to $($item.Group): $_" -ForegroundColor Red
    }
}

Write-Host "RBAC role groups and memberships applied successfully." -ForegroundColor Green
