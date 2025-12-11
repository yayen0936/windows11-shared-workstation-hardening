param()

<#
.SYNOPSIS
    Enables AppLocker and applies a restrictive baseline.

.DESCRIPTION
    Allows:
      - Microsoft signed executables
      - Programs inside Program Files & Windows
    Blocks unknown executables.
#>

# Enable AppLocker service
Set-Service -Name AppIDSvc -StartupType Automatic
Start-Service AppIDSvc

# Default allow rules
$PolicyXML = @"
<AppLockerPolicy Version="1">
  <RuleCollection Type="Exe" EnforcementMode="Enabled">
    <FilePublisherRule Id="1" Name="Allow Microsoft" Description="" UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePublisherCondition PublisherName="O=MICROSOFT CORPORATION, L=REDMOND, S=WASHINGTON, C=US"/>
      </Conditions>
    </FilePublisherRule>
    <FilePathRule Id="2" Name="Allow Program Files" Description="" UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePathCondition Path="%PROGRAMFILES%\*"/>
      </Conditions>
    </FilePathRule>
    <FilePathRule Id="3" Name="Allow Windows" Description="" UserOrGroupSid="S-1-1-0" Action="Allow">
      <Conditions>
        <FilePathCondition Path="%WINDIR%\*"/>
      </Conditions>
    </FilePathRule>
  </RuleCollection>
</AppLockerPolicy>
"@

$TempPolicy = "$env:TEMP\AppLockerPolicy.xml"
$PolicyXML | Out-File -FilePath $TempPolicy -Encoding ASCII

Set-AppLockerPolicy -PolicyFilePath $TempPolicy -Merge

Write-Host "AppLocker baseline applied." -ForegroundColor Green
