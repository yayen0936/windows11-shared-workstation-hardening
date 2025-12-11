param()

<#
.SYNOPSIS
    Applies a standard advanced audit policy baseline.

.DESCRIPTION
    Uses auditpol.exe to enable auditing for:
    - Logon/logoff
    - Privilege use
    - Policy change
    - System events
#>

# Example audit baseline
$auditSettings = @(
    "Logon", "Success and Failure",
    "Account Logon", "Success and Failure",
    "Policy Change", "Success and Failure",
    "Privilege Use", "Success",
    "System", "Success and Failure"
)

auditpol.exe /set /category:"Logon" /success:enable /failure:enable
auditpol.exe /set /category:"Account Logon" /success:enable /failure:enable
auditpol.exe /set /category:"Policy Change" /success:enable /failure:enable
auditpol.exe /set /category:"Privilege Use" /success:enable
auditpol.exe /set /category:"System" /success:enable /failure:enable

Write-Host "Advanced audit policy baseline applied." -ForegroundColor Green
