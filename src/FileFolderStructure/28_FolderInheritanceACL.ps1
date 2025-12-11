param()

<#
.SYNOPSIS
    Breaks inheritance and removes all inherited NTFS permissions
    on the SecurePro folder structure.

.DESCRIPTION
    - Disables inherited permissions
    - Removes inherited ACEs completely (no copy)
    - Retains SYSTEM and Administrators only
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

    if (-not (Test-Path $Folder)) {
        New-Item -Path $Folder -ItemType Directory | Out-Null
    }

    Write-Host "Breaking inheritance on: $Folder" -ForegroundColor Cyan

    $acl = Get-Acl $Folder

    # Disable inheritance and remove inherited ACEs
    $acl.SetAccessRuleProtection($true, $false)

    # Remove all ACEs except SYSTEM + Administrators
    foreach ($ace in $acl.Access) {
        if ($ace.IdentityReference -notmatch "SYSTEM" -and
            $ace.IdentityReference -notmatch "Administrators") {

            Write-Host "Removing ACE: $($ace.IdentityReference)"
            $acl.RemoveAccessRule($ace) | Out-Null
        }
    }

    Set-Acl -Path $Folder -AclObject $acl
}

Write-Host "Folder inheritance successfully removed on all target folders." -ForegroundColor Green
