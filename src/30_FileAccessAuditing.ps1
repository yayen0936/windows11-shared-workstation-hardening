param()

<#
.SYNOPSIS
    Enables NTFS auditing for sensitive folders.

.DESCRIPTION
    Audits:
    - Read
    - Write
    - Delete

    Must be combined with:
    - CC16 Advanced Audit Policy
#>

# -------------------------
# DEFINE AUDIT TARGETS
# -------------------------
$AuditFolders = @(
    "C:\Data\HR",
    "C:\Data\Finance"
)

foreach ($folder in $AuditFolders) {

    Write-Host "Applying file access auditing to: $folder" -ForegroundColor Cyan

    if (-not (Test-Path $folder)) { continue }

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

Write-Host "NTFS auditing applied to sensitive folders." -ForegroundColor Green
