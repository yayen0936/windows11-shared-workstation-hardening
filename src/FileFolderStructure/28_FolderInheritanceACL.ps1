param()

<#
.SYNOPSIS
    Safely breaks inheritance and removes all inherited NTFS permissions
    on the SecurePro folder structure.

.DESCRIPTION
    - Ensures SYSTEM + Administrators are explicitly added BEFORE disabling inheritance
    - Disables inherited permissions
    - Removes inherited ACEs (no copy)
    - Prevents transient Access Denied issues
    - Prepares folders for least-privilege NTFS baseline (script 29)
#>

$Base = "D:\SecurePro"

# List of folders that must have inheritance removed
$Folders = @(
    "$Base",
    "$Base\1_Active_Jobs",
    "$Base\2_Company_Administration",
    "$Base\2_Company_Administration\Finance",
    "$Base\2_Company_Administration\HR",
    "$Base\2_Company_Administration\HR\Employee_Files",
    "$Base\3_Sales_Marketing",
    "$Base\4_Resources",
    "$Base\5_Archives"
)

foreach ($Folder in $Folders) {

    # Ensure folder exists
    if (-not (Test-Path $Folder)) {
        New-Item -Path $Folder -ItemType Directory | Out-Null
    }

    Write-Host "`nProcessing: $Folder" -ForegroundColor Cyan

    # Get ACL
    $acl = Get-Acl $Folder

    # -----------------------------------------------------------
    # STEP 1 — Ensure SYSTEM + Administrators are explicitly added
    # -----------------------------------------------------------

    $systemRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "SYSTEM","FullControl","ContainerInherit,ObjectInherit","None","Allow"
    )

    $adminRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "Administrators","FullControl","ContainerInherit,ObjectInherit","None","Allow"
    )

    $acl.SetAccessRule($systemRule)
    $acl.SetAccessRule($adminRule)

    # -----------------------------------------------------------
    # STEP 2 — Break inheritance AFTER explicit ACEs exist
    # -----------------------------------------------------------

    Write-Host " - Breaking inheritance" -ForegroundColor Yellow
    $acl.SetAccessRuleProtection($true, $false)   # Disable inheritance, remove inherited ACEs

    # -----------------------------------------------------------
    # STEP 3 — Remove all ACEs except SYSTEM + Administrators
    # -----------------------------------------------------------

    foreach ($ace in $acl.Access) {
        if ($ace.IdentityReference -notmatch "SYSTEM" -and
            $ace.IdentityReference -notmatch "Administrators") {

            Write-Host "   Removing ACE: $($ace.IdentityReference)"
            $acl.RemoveAccessRule($ace) | Out-Null
        }
    }

    # Apply updated ACL
    Set-Acl -Path $Folder -AclObject $acl

    Write-Host " - Completed: $Folder" -ForegroundColor Green
}

Write-Host "`nFolder inheritance successfully removed on all target folders." -ForegroundColor Green
