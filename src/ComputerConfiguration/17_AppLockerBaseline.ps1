param()

<#
.SYNOPSIS
    Enables AppLocker and applies a restrictive executable baseline.

.DESCRIPTION
    Enforces application control for executable files by starting the
    Application Identity service and applying an AppLocker EXE policy that
    allows execution only from trusted system locations (Windows and Program
    Files) while denying execution from user-writable profile paths
    (e.g., %OSDRIVE%\Users\*). Local Administrators are explicitly allowed to
    run executables from any location to support controlled IT administration
    and troubleshooting.
#>

$ErrorActionPreference = 'Stop'

# --------------------------------------------------
# Pre-check: Must run as Administrator
# --------------------------------------------------
$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

try {
    # --------------------------------------------------
    # Enable Application Identity service (required)
    # --------------------------------------------------
    Write-Host "[*] Configuring Application Identity service..." -ForegroundColor Cyan

    & sc.exe config AppIDSvc start= auto | Out-Null
    Start-Service AppIDSvc -ErrorAction SilentlyContinue

    $svc = Get-Service AppIDSvc
    if ($svc.Status -ne 'Running') {
        throw "Application Identity service is not running."
    }

    Write-Host "[+] Application Identity service is running." -ForegroundColor Green

    # --------------------------------------------------
    # Generate GUIDs for AppLocker rules
    # --------------------------------------------------
    $IdDenyUsers = ([guid]::NewGuid()).Guid
    $IdWin       = ([guid]::NewGuid()).Guid
    $IdPF        = ([guid]::NewGuid()).Guid
    $IdAdmins    = ([guid]::NewGuid()).Guid

    # --------------------------------------------------
    # AppLocker XML Policy (EXE rules)
    # --------------------------------------------------
    $PolicyXML = @"
<AppLockerPolicy Version="1">
  <RuleCollection Type="Exe" EnforcementMode="Enabled">

    <!-- DENY: User-writable locations -->
    <FilePathRule Id="$IdDenyUsers"
                  Name="Deny Executables in User Profiles"
                  Description="Blocks execution from user-writable directories"
                  UserOrGroupSid="S-1-1-0"
                  Action="Deny">
      <Conditions>
        <FilePathCondition Path="%OSDRIVE%\Users\*" />
      </Conditions>
    </FilePathRule>

    <!-- ALLOW: Windows directory -->
    <FilePathRule Id="$IdWin"
                  Name="Allow Windows Directory"
                  Description=""
                  UserOrGroupSid="S-1-1-0"
                  Action="Allow">
      <Conditions>
        <FilePathCondition Path="%WINDIR%\*" />
      </Conditions>
    </FilePathRule>

    <!-- ALLOW: Program Files -->
    <FilePathRule Id="$IdPF"
                  Name="Allow Program Files"
                  Description=""
                  UserOrGroupSid="S-1-1-0"
                  Action="Allow">
      <Conditions>
        <FilePathCondition Path="%PROGRAMFILES%\*" />
      </Conditions>
    </FilePathRule>

    <!-- ALLOW: Local Administrators (full access) -->
    <FilePathRule Id="$IdAdmins"
                  Name="Allow All for Local Administrators"
                  Description=""
                  UserOrGroupSid="S-1-5-32-544"
                  Action="Allow">
      <Conditions>
        <FilePathCondition Path="*" />
      </Conditions>
    </FilePathRule>

  </RuleCollection>
</AppLockerPolicy>
"@

    # --------------------------------------------------
    # Apply AppLocker policy
    # --------------------------------------------------
    $TempPolicy = Join-Path $env:TEMP "AppLockerPolicy.xml"
    $PolicyXML | Out-File -FilePath $TempPolicy -Encoding UTF8 -Force

    Write-Host "[*] Applying AppLocker baseline..." -ForegroundColor Cyan
    Set-AppLockerPolicy -XmlPolicy $TempPolicy -Merge -ErrorAction Stop

    Write-Host "[+] AppLocker baseline applied successfully." -ForegroundColor Green
    exit 0
}
catch {
    Write-Error $_
    exit 1
}
