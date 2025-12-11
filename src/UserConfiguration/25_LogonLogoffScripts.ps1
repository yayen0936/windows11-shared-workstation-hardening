param()

<#
.SYNOPSIS
    Configures logon/logoff scripts for hygiene.

.DESCRIPTION
    - Clears temp files
    - Logs session start/end
    - Enforces environment variables
#>

$LogDir = "$env:SystemDrive\Logs"
$ScriptsPath = "$LogDir\Hygiene"

# Ensure folders exist
New-Item -Path $ScriptsPath -ItemType Directory -Force | Out-Null

# Logon Script
$LogonScript = @"
echo Logon at %DATE% %TIME% >> "$LogDir\logon.log"
del /q %TEMP%\*
"@
$LogOnFile = Join-Path $ScriptsPath "Logon.cmd"
[System.IO.File]::WriteAllText($LogOnFile, $LogonScript)

# Logoff Script
$LogoffScript = @"
echo Logoff at %DATE% %TIME% >> "$LogDir\logoff.log"
"@
$LogOffFile = Join-Path $ScriptsPath "Logoff.cmd"
[System.IO.File]::WriteAllText($LogOffFile, $LogoffScript)

# Register scripts
$Reg = "HKCU:\Environment"
Set-ItemProperty -Path $Reg -Name "UserInitMprLogonScript" -Value $LogOnFile

Write-Host "Logon/logoff hygiene scripts configured." -ForegroundColor Green
