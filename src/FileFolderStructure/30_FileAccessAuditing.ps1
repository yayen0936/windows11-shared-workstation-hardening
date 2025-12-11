param()

<#
.SYNOPSIS
    Enables NTFS auditing for sensitive folders.

.DESCRIPTION
    Applies audit rules for Finance and HR Employee_Files.
#>

$AuditTargets = @(
    "D:\SecurePro\2_Company_Administration\Finance",
    "D:\SecurePro\2_Company_Administration\HR\Employee_Files"
)

foreach ($folder in $AuditTargets) {

    if (-not (Test-Path $folder)) { continue }

    Write-Host "Applying auditing to: $folder" -ForegroundColor Cyan

    $acl = Get-Acl $folder

    $auditRule = New-Object System.Security.AccessControl.FileSystemAuditRule(
        "Everyone",
        "Read, Write, Delete",
        "ContainerInherit, ObjectInherit",
        "None",
        "Success, Failure"
    )

    $acl.AddAuditRule($auditRule)
    Set-Acl -Path $folder -AclObject $acl
}

Write-Host "Auditing applied to critical folders." -ForegroundColor Green
