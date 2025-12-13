param()

<#
.SYNOPSIS
    Enables SmartScreen and reputation-based protection.

.DESCRIPTION
    Enforces SmartScreen and reputation-based protections for Windows and
    Microsoft Edge to warn users when launching untrusted or potentially
    malicious applications and websites. These controls help prevent users
    from executing unknown or low-reputation content, reducing the risk of
    malware infection and social-engineering-based attacks on shared
    workstations.
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
