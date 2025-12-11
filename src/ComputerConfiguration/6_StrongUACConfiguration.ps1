param()

<#
.SYNOPSIS
    Configures User Account Control (UAC) hardening.

.DESCRIPTION
    Equivalent to:
    Local Security Policy ->
        Security Settings ->
            Local Policies ->
                Security Options ->
                    User Account Control
#>

$UACPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# UAC settings
Set-ItemProperty -Path $UACPath -Name "EnableLUA" -Value 1
Set-ItemProperty -Path $UACPath -Name "ConsentPromptBehaviorAdmin" -Value 2   # Prompt for credentials
Set-ItemProperty -Path $UACPath -Name "ConsentPromptBehaviorUser" -Value 0    # Deny elevation for standard users
Set-ItemProperty -Path $UACPath -Name "PromptOnSecureDesktop" -Value 1        # Secure Desktop prompts

Write-Host "Strong UAC configuration applied!" -ForegroundColor Green
