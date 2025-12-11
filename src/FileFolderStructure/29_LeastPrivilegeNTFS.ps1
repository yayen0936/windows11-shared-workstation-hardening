param()

<#
.SYNOPSIS
    Applies strict NTFS baseline to the root data location.

.DESCRIPTION
    - Removes Everyone/Users
    - Grants FullControl only to SYSTEM + Administrators
#>

$DataRoot = "D:\SecurePro"
# Create root folder if missing
if (-not (Test-Path $DataRoot)) {
    New-Item -Path $DataRoot -ItemType Directory | Out-Null
}

Write-Host "Applying least-privilege NTFS ACL to $DataRoot" -ForegroundColor Cyan

$acl = Get-Acl $DataRoot

# Remove insecure ACEs
$acl.Access | ForEach-Object {
    if ($_.IdentityReference -match "Everyone" -or $_.IdentityReference -match "Users") {
        Write-Host "Removing ACL: $($_.IdentityReference)"
        $acl.RemoveAccessRule($_) | Out-Null
    }
}

# Add secure baseline ACEs
$entries = @(
    @{ Identity="NT AUTHORITY\SYSTEM"; Rights="FullControl" }
    @{ Identity="BUILTIN\Administrators"; Rights="FullControl" }
)

foreach ($entry in $entries) {
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule (
        [System.Security.Principal.NTAccount]$entry.Identity,
        [System.Security.AccessControl.FileSystemRights]::$($entry.Rights),
        [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit",
        [System.Security.AccessControl.PropagationFlags]::None,
        [System.Security.AccessControl.AccessControlType]::Allow
    )

    $acl.SetAccessRule($rule)
}

Set-Acl -Path $DataRoot -AclObject $acl

Write-Host "Least-privilege baseline applied to $DataRoot" -ForegroundColor Green
