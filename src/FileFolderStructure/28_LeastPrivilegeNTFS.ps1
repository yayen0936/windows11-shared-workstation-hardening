param()

<#
.SYNOPSIS
    Applies strict NTFS permissions to the data root.

.DESCRIPTION
    - Removes BUILTIN\Users and Everyone
    - Grants full control only to SYSTEM and Administrators
#>

$DataRoot = "C:\Data"     # Change as needed

# Ensure folder exists
if (-not (Test-Path $DataRoot)) {
    New-Item -Path $DataRoot -ItemType Directory | Out-Null
}

Write-Host "Applying least-privilege NTFS ACL to $DataRoot" -ForegroundColor Cyan

$acl = Get-Acl $DataRoot

# Remove insecure ACEs
$acl.Access | ForEach-Object {
    if ($_.IdentityReference -match "Everyone" -or $_.IdentityReference -match "Users") {
        Write-Host "Removing ACL: $($_.IdentityReference)"
        $acl.RemoveAccessRule($_)
    }
}

# Add secure ACEs
$rules = @(
    New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM","FullControl","ContainerInherit, ObjectInherit","None","Allow"),
    New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl","ContainerInherit, ObjectInherit","None","Allow")
)

foreach ($rule in $rules) {
    $acl.SetAccessRule($rule)
}

Set-Acl -Path $DataRoot -AclObject $acl

Write-Host "Least-privilege NTFS baseline applied to $DataRoot" -ForegroundColor Green
