param()

<#
.SYNOPSIS
    Enables SmartScreen and reputation-based protection.

.DESCRIPTION
    Configures Windows SmartScreen for:
    - Microsoft Edge
    - Windows apps
    - Untrusted executable warnings

    GPO equivalent:
    Computer Configuration ->
        Administrative Templates ->
            Windows Components ->
                Windows Defender SmartScreen
#>

$SmartScreenPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"

# Enable SmartScreen for apps
Set-ItemProperty -Path $SmartScreenPath -Name "EnableSmartScreen" -Value 1 -Force
Set-ItemProperty -Path $SmartScreenPath -Name "ShellSmartScreenLevel" -Value "Warn" -Force

# Enable SmartScreen for Microsoft Edge
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
New-Item -Path $EdgePath -Force | Out-Null
Set-ItemProperty -Path $EdgePath -Name "SmartScreenEnabled" -Value 1
Set-ItemProperty -Path $EdgePath -Name "PreventSmartScreenPromptOverride" -Value 1

Write-Host "SmartScreen and reputation-based protection enabled." -ForegroundColor Green
