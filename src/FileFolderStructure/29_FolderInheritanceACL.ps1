param()

<#
.SYNOPSIS
    Applies folder-level RBAC ACLs with broken inheritance.

.DESCRIPTION
    Based on SecurePro folder structure and departmental groups.
#>

$Base = "D:\SecurePro"

$Folders = @(
    @{ Path="$Base\1_Active_Jobs";                    RW=@("Estimating_Design","Operations_Sales"); RO=@("Finance_Administration") }

    @{ Path="$Base\2_Company_Administration\Finance"; RW=@("Finance_Administration"); RO=@() }

    @{ Path="$Base\2_Company_Administration\HR\Employee_Files"; RW=@(); RO=@() }   # Highly restricted

    @{ Path="$Base\3_Sales_Marketing";                 RW=@("Operations_Sales"); RO=@("Estimating_Design") }

    @{ Path="$Base\4_Resources";                       RW=@(); RO=@("Estimating_Design","Finance_Administration","Operations_Sales") }
)

foreach ($f in $Folders) {

    if (-not (Test-Path $f.Path)) { New-Item -Path $f.Path -ItemType Directory | Out-Null }

    Write-Host "Applying ACLs to: $($f.Path)" -ForegroundColor Cyan

    $acl = Get-Acl $f.Path

    # Break inheritance
    $acl.SetAccessRuleProtection($true, $true)

    # Remove all ACEs except SYSTEM + Administrators
    $acl.Access | Where-Object {
        $_.IdentityReference -notmatch "SYSTEM" -and
        $_.IdentityReference -notmatch "Administrators"
    } | ForEach-Object {
        Write-Host "Removing ACL: $($_.IdentityReference)"
        $acl.RemoveAccessRule($_)
    }

    # RW groups
    foreach ($g in $f.RW) {
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $g,"Modify","ContainerInherit, ObjectInherit","None","Allow"
        )
        $acl.AddAccessRule($rule)
    }

    # RO groups
    foreach ($g in $f.RO) {
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $g,"ReadAndExecute","ContainerInherit, ObjectInherit","None","Allow"
        )
        $acl.AddAccessRule($rule)
    }

    Set-Acl -Path $f.Path -AclObject $acl
}

Write-Host "Departmental RBAC ACLs applied." -ForegroundColor Green
