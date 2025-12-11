param()

<#
.SYNOPSIS
    Applies a strict least-privilege NTFS baseline to the SecurePro
    root folder after inheritance has been removed.

.DESCRIPTION
    - Removes residual insecure ACEs (Everyone, Users, Authenticated Users)
    - Grants FullControl only to SYSTEM and Administrators
    - Applies inheritance flags so subfolders automatically inherit
      the least-privilege baseline
#>

$DataRoot = "D:\SecurePro"

# Ensure folder exists
if (-not (Test-Path $DataRoot)) {
    New-Item -Path $DataRoot -ItemType Directory | Out-Null
}

Write-Host "Applying least-privilege NTFS baseline to $DataRoot" -ForegroundColor Cyan

$acl = Get-Acl $DataRoot

# Remove insecure ACEs (catch all variations)
$toRemovePatterns = @("Everyone", "Users", "Authenticated Users")

foreach ($ace in $acl.Access) {
    foreach ($pattern in $toRemovePatterns) {
        if ($ace.IdentityReference -match $pattern) {
            Write-Host "Removing ACL: $($ace.IdentityReference)"
            $acl.RemoveAccessRule($ace) | Out-Null
        }
    }
}

# Add strict baseline ACEs
$SecureEntries = @(
    @{ Identity = "NT AUTHORITY\SYSTEM";          Rights = "FullControl" }
    @{ Identity = "BUILTIN\Administrators";       Rights = "FullControl" }
)

foreach ($entry in $SecureEntries) {

    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule (
        [System.Security.Principal.NTAccount]$entry.Identity,
        [System.Security.AccessControl.FileSystemRights]::$($entry.Rights),
        [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit",
        [System.Security.AccessControl.PropagationFlags]::None,
        [System.Security.AccessControl.AccessControlType]::Allow
    )

    Write-Host "Setting baseline ACE: $($entry.Identity) - $($entry.Rights)"
    $acl.SetAccessRule($rule)
}

# Apply updated security descriptor
Set-Acl -Path $DataRoot -AclObject $acl

Write-Host "Least-privilege NTFS baseline successfully applied to $DataRoot" -ForegroundColor Green
