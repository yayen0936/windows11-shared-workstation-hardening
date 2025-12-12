param()

<#
.SYNOPSIS
    Applies department-based RBAC permissions to the SecurePro folder structure.

.DESCRIPTION
    - Assigns Modify (RW) and ReadAndExecute (RO) permissions
      to departmental groups based on the RBAC model.
    - All permissions are explicit because inheritance was removed earlier.
#>

$Base = "D:\SecurePro"

# RBAC DEFINITIONS
$Folders = @(
    @{
        Path = "$Base\1_Active_Jobs"
        RW   = @("Estimating_Design", "Operations_Sales")
        RO   = @("Finance_Administration")
    },
    @{
        Path = "$Base\2_Company_Administration\Finance"
        RW   = @("Finance_Administration")
        RO   = @()
    },
    @{
        Path = "$Base\2_Company_Administration\HR\Employee_Files"
        RW   = @()
        RO   = @()
    },
    @{
        Path = "$Base\3_Sales_Marketing"
        RW   = @("Operations_Sales")
        RO   = @("Estimating_Design")
    },
    @{
        Path = "$Base\4_Resources"
        RW   = @()
        RO   = @("Estimating_Design", "Finance_Administration", "Operations_Sales")
    }
)

Write-Host "`nApplying RBAC folder permissions..." -ForegroundColor Cyan

foreach ($f in $Folders) {

    $folderPath = $f.Path

    if (-not (Test-Path $folderPath)) {
        Write-Host "Missing folder - creating: $folderPath"
        New-Item -Path $folderPath -ItemType Directory | Out-Null
    }

    Write-Host "`nProcessing: $folderPath" -ForegroundColor Yellow

    $acl = Get-Acl $folderPath

    # APPLY READ/WRITE PERMISSIONS
    foreach ($group in $f.RW) {
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $group,
            "Modify",
            "ContainerInherit, ObjectInherit",
            "None",
            "Allow"
        )
        Write-Host "  [RW] $group"
        $acl.AddAccessRule($rule)
    }

    # APPLY READ-ONLY PERMISSIONS
    foreach ($group in $f.RO) {
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $group,
            "ReadAndExecute",
            "ContainerInherit, ObjectInherit",
            "None",
            "Allow"
        )
        Write-Host "  [RO] $group"
        $acl.AddAccessRule($rule)
    }

    # Apply updated ACL
    Set-Acl -Path $folderPath -AclObject $acl
}

Write-Host "`nRBAC permissions successfully applied." -ForegroundColor Green
