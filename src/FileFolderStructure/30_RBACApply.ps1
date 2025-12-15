param()

<#
.SYNOPSIS
    Applies department-based RBAC permissions to the SecurePro folder structure.

.DESCRIPTION
    - Assigns Modify (RW), ReadAndExecute (R), and FullControl (Full)
      to departmental groups based on the RBAC model.
    - All permissions are explicit because inheritance was removed earlier.
#>

# --------------------------------------------------
# Require Administrator (needed for Get-Acl/Set-Acl on protected folders)
# --------------------------------------------------
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Error "This script must be run as Administrator (elevated)."
    exit 1
}

$Base = "D:\SecurePro"

# RBAC DEFINITIONS
$Folders = @(
    @{ Path = "$Base"; RW=@(); RO=@("Estimating_Design","Finance_Administration","Operations_Sales"); FULL=@("IT") },

    # Active Jobs
    @{ Path = "$Base\1_Active_Jobs"; RW=@("Estimating_Design","Operations_Sales"); RO=@("Finance_Administration"); FULL=@("IT") },
    @{ Path = "$Base\1_Active_Jobs\2024_001_ElmSt_Mansion"; RW=@("Estimating_Design","Operations_Sales"); RO=@("Finance_Administration"); FULL=@("IT") },
    @{ Path = "$Base\1_Active_Jobs\2024_002_MapleAve_Condo"; RW=@("Estimating_Design","Operations_Sales"); RO=@("Finance_Administration"); FULL=@("IT") },
    @{ Path = "$Base\1_Active_Jobs\2024_003_OakDr_Retail"; RW=@("Estimating_Design","Operations_Sales"); RO=@("Finance_Administration"); FULL=@("IT") },

    # Company Administration (container)
    @{ Path = "$Base\2_Company_Administration"; RW=@(); RO=@(); FULL=@("IT") },

    # Finance
    @{ Path = "$Base\2_Company_Administration\Finance"; RW=@("Finance_Administration"); RO=@(); FULL=@("IT") },
    @{ Path = "$Base\2_Company_Administration\Finance\Invoices_Outgoing"; RW=@("Finance_Administration"); RO=@(); FULL=@("IT") },
    @{ Path = "$Base\2_Company_Administration\Finance\Invoices_Incoming"; RW=@("Finance_Administration"); RO=@(); FULL=@("IT") },
    @{ Path = "$Base\2_Company_Administration\Finance\Payroll_Reports"; RW=@("Finance_Administration"); RO=@(); FULL=@("IT") },

    # HR
    @{ Path = "$Base\2_Company_Administration\HR"; RW=@("Finance_Administration"); RO=@(); FULL=@("IT") },
    @{ Path = "$Base\2_Company_Administration\HR\Employee_Files"; RW=@("Finance_Administration"); RO=@(); FULL=@("IT") },
    @{ Path = "$Base\2_Company_Administration\HR\Policies"; RW=@("Finance_Administration"); RO=@("Estimating_Design","Operations_Sales"); FULL=@("IT") },

    # Operations (under Company Administration)
    @{ Path = "$Base\2_Company_Administration\Operations"; RW=@("Operations_Sales"); RO=@("Finance_Administration"); FULL=@("IT") },
    @{ Path = "$Base\2_Company_Administration\Operations\Crew_Schedules"; RW=@("Operations_Sales"); RO=@("Finance_Administration"); FULL=@("IT") },
    @{ Path = "$Base\2_Company_Administration\Operations\Vehicle_Maintenance"; RW=@("Operations_Sales"); RO=@("Finance_Administration"); FULL=@("IT") },

    # Sales & Marketing
    @{ Path = "$Base\3_Sales_Marketing"; RW=@("Operations_Sales"); RO=@("Estimating_Design"); FULL=@("IT") },
    @{ Path = "$Base\3_Sales_Marketing\CRM_Exports"; RW=@("Operations_Sales"); RO=@(); FULL=@("IT") },
    @{ Path = "$Base\3_Sales_Marketing\Marketing_Materials"; RW=@("Operations_Sales"); RO=@("Estimating_Design"); FULL=@("IT") },
    @{ Path = "$Base\3_Sales_Marketing\Proposals_Templates"; RW=@("Operations_Sales"); RO=@("Estimating_Design"); FULL=@("IT") },

    # Resources
    @{ Path = "$Base\4_Resources"; RW=@(); RO=@("Estimating_Design","Finance_Administration","Operations_Sales"); FULL=@("IT") },
    @{ Path = "$Base\4_Resources\Material_Catalogs"; RW=@(); RO=@("Estimating_Design","Finance_Administration","Operations_Sales"); FULL=@("IT") },
    @{ Path = "$Base\4_Resources\Installation_Manuals"; RW=@(); RO=@("Estimating_Design","Finance_Administration","Operations_Sales"); FULL=@("IT") },
    @{ Path = "$Base\4_Resources\Safety_Protocols"; RW=@(); RO=@("Estimating_Design","Finance_Administration","Operations_Sales"); FULL=@("IT") },

    # Archives
    @{ Path = "$Base\5_Archives"; RW=@(); RO=@(); FULL=@("IT") },
    @{ Path = "$Base\5_Archives\Completed_Jobs_2023"; RW=@(); RO=@("Estimating_Design","Finance_Administration","Operations_Sales"); FULL=@("IT") },
    @{ Path = "$Base\5_Archives\Financial_Records_2023"; RW=@(); RO=@("Finance_Administration"); FULL=@("IT") }
)

Write-Host "`nApplying RBAC folder permissions..." -ForegroundColor Cyan

foreach ($f in $Folders) {

    $folderPath = $f.Path

    try {
        if (-not (Test-Path $folderPath -ErrorAction Stop)) {
            Write-Host "Missing folder - creating: $folderPath"
            New-Item -Path $folderPath -ItemType Directory -Force -ErrorAction Stop | Out-Null
        }
    }
    catch {
        Write-Warning "Access denied checking/creating: $folderPath"
        Write-Warning $_.Exception.Message
        continue
    }

    Write-Host "`nProcessing: $folderPath" -ForegroundColor Yellow

    try {
        $acl = Get-Acl $folderPath -ErrorAction Stop
    }
    catch {
        Write-Warning "Access denied reading ACL: $folderPath"
        Write-Warning $_.Exception.Message
        continue
    }

    # APPLY READ/WRITE PERMISSIONS (RW = Modify)
    foreach ($group in $f.RW) {
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $group, "Modify", "ContainerInherit, ObjectInherit", "None", "Allow"
        )
        Write-Host "  [RW] $group"
        $acl.AddAccessRule($rule)
    }

    # APPLY READ-ONLY PERMISSIONS (R = ReadAndExecute)
    foreach ($group in $f.RO) {
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $group, "ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow"
        )
        Write-Host "  [R]  $group"
        $acl.AddAccessRule($rule)
    }

    # APPLY FULL CONTROL PERMISSIONS (Full = FullControl)
    foreach ($group in $f.FULL) {
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $group, "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"
        )
        Write-Host "  [FULL] $group"
        $acl.AddAccessRule($rule)
    }

    try {
        Set-Acl -Path $folderPath -AclObject $acl -ErrorAction Stop
    }
    catch {
        Write-Warning "Access denied applying ACL: $folderPath"
        Write-Warning $_.Exception.Message
        continue
    }
}

Write-Host "`nRBAC permissions successfully applied." -ForegroundColor Green