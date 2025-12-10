param()

<#
.SYNOPSIS
    Applies RBAC-based NTFS permissions to department folders.

.DESCRIPTION
    - Breaks inheritance
    - Applies RW/RO groups explicitly
#>

# -------------------------
# DEFINE FOLDERS + GROUPS
# -------------------------
$Folders = @(
    @{ Path="C:\Data\HR";        RW="Data_HR_RW";        RO="Data_HR_RO" },
    @{ Path="C:\Data\Finance";   RW="Data_Finance_RW";   RO="Data_Finance_RO" }
)

foreach ($f in $Folders) {

    # Ensure folder exists
    if (-not (Test-Path $f.Path)) {
        New-Item -Path $f.Path -ItemType Directory | Out-Null
    }

    Write-Host "Applying ACLs to: $($f.Path)" -ForegroundColor Cyan
    $acl = Get-Acl $f.Path

    # Break inheritance but copy existing ACEs (required for SYSTEM)
    $acl.SetAccessRuleProtection($true, $true)

    # Remove all existing ACEs except SYSTEM and Administrators
    $acl.Access | Where-Object {
        $_.IdentityReference -notmatch "SYSTEM" -and
        $_.IdentityReference -notmatch "Administrators"
    } | ForEach-Object {
        Write-Host "Removing ACL: $($_.IdentityReference)"
        $acl.RemoveAccessRule($_)
    }

    # Add RW group
    if ($f.RW) {
        $ruleRW = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $f.RW, "Modify", "ContainerInherit, ObjectInherit", "None", "Allow"
        )
        $acl.AddAccessRule($ruleRW)
    }

    # Add RO group
    if ($f.RO) {
        $ruleRO = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $f.RO, "ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow"
        )
        $acl.AddAccessRule($ruleRO)
    }

    Set-Acl -Path $f.Path -AclObject $acl
}

Write-Host "RBAC folder ACLs applied." -ForegroundColor Green
