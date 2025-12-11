param()

<#
.SYNOPSIS
    Minimizes members of the local Administrators group.

.DESCRIPTION
    Ensures only approved admin accounts remain in the local Administrators
    group. Removes all unapproved or standard users.

    Equivalent to:
    Computer Configuration ->
        Windows Settings ->
            Security Settings ->
                Local Policies ->
                    User Rights Assignment ->
                        "Administrators"
#>

# -------------------------
# CONFIGURE APPROVED ADMINS
# -------------------------
$ApprovedAdmins = @(
    "Administrator",       # Built-in admin (optional)
    "yayen-admin"          # Example - replace with your real admin
)

# -------------------------
# GET CURRENT MEMBERS
# -------------------------
$current = Get-LocalGroupMember -Group "Administrators"

foreach ($member in $current) {
    if ($ApprovedAdmins -notcontains $member.Name) {
        Write-Host "Removing unauthorized admin: $($member.Name)" -ForegroundColor Yellow
        Remove-LocalGroupMember -Group "Administrators" -Member $member.Name -ErrorAction SilentlyContinue
    }
}

# -------------------------
# ADD APPROVED ADMINS BACK
# -------------------------
foreach ($admin in $ApprovedAdmins) {
    try {
        Add-LocalGroupMember -Group "Administrators" -Member $admin -ErrorAction Stop
        Write-Host "Ensured authorized admin: $admin"
    }
    catch { }
}

Write-Host "Local Administrators group minimized successfully!" -ForegroundColor Green
