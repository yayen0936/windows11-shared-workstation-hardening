param()

<#
.SYNOPSIS
    Applies a standard advanced audit policy baseline.

.DESCRIPTION
    Enforces an advanced auditing baseline using auditpol.exe to record key
    security-relevant events, including logon/logoff activity, account logon
    events, policy changes, privilege use, and system events. This improves
    visibility and accountability by generating audit trails needed for
    incident detection, investigation, and compliance on shared workstations.
#>

Write-Host "[*] Applying Advanced Audit Policy baseline..." -ForegroundColor Cyan

# FIXED: "Logon" is not a valid AuditPol category on Windows; use "Logon/Logoff"
$auditBaseline = @(
    @{ Category = "Logon/Logoff";  Success = "enable"; Failure = "enable" },
    @{ Category = "Account Logon"; Success = "enable"; Failure = "enable" },
    @{ Category = "Policy Change"; Success = "enable"; Failure = "enable" },
    @{ Category = "Privilege Use"; Success = "enable"; Failure = "disable" },
    @{ Category = "System";        Success = "enable"; Failure = "enable" }
)

foreach ($item in $auditBaseline) {
    & auditpol.exe /set /category:"$($item.Category)" /success:$($item.Success) /failure:$($item.Failure) 2>$null | Out-Null

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to set audit policy for category '$($item.Category)'. Exit code: $LASTEXITCODE"
        Write-Host "Check: C:\Windows\Security\Logs\scesrv.log (if applicable) or run 'auditpol /get /category:*' for context." -ForegroundColor Yellow
        exit 1
    }

    Write-Host ("[+] {0,-14}  Success={1}  Failure={2}" -f $item.Category, $item.Success, $item.Failure) -ForegroundColor Green
}

Write-Host ""
Write-Host "[*] Verification (Current Audit Policy - configured categories)" -ForegroundColor Cyan
Write-Host "--------------------------------------------------------------"

foreach ($item in $auditBaseline) {
    Write-Host ""
    Write-Host ("--- {0} ---" -f $item.Category) -ForegroundColor Yellow

    $out = & auditpol.exe /get /category:"$($item.Category)" 2>$null
    ($out -split "`r?`n") | ForEach-Object {
        if ($_.Trim()) { Write-Host $_ }
    }
}

Write-Host "--------------------------------------------------------------"
Write-Host "Advanced audit policy baseline applied." -ForegroundColor Green