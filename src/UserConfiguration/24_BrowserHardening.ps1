param()

<#
.SYNOPSIS
    Applies browser hardening for Edge.

.DESCRIPTION
    - Set homepage
    - Force SmartScreen
    - Restrict extensions
#>

$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"

New-Item -Path $EdgePath -Force | Out-Null

# Homepage
Set-ItemProperty -Path $EdgePath -Name "HomepageLocation" -Value "https://www.bing.com"
Set-ItemProperty -Path $EdgePath -Name "RestoreOnStartup" -Value 4
Set-ItemProperty -Path $EdgePath -Name "RestoreOnStartupURLs" -Value @("https://www.bing.com")

# SmartScreen
Set-ItemProperty -Path $EdgePath -Name "SmartScreenEnabled" -Value 1
Set-ItemProperty -Path $EdgePath -Name "PreventSmartScreenPromptOverride" -Value 1

# Block all extensions by default
Set-ItemProperty -Path $EdgePath -Name "ExtensionInstallBlocklist" -Value "*" -Force

Write-Host "Browser hardening applied for Microsoft Edge." -ForegroundColor Green
