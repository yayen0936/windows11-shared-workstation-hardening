param()

<#
.SYNOPSIS
    Configures User Account Control (UAC) hardening.

.DESCRIPTION
    Enforces a hardened User Account Control (UAC) configuration by requiring
    secure elevation prompts for administrators, denying elevation requests
    from standard users, and displaying prompts on the secure desktop. These
    settings reduce the risk of unauthorized privilege escalation and ensure
    that administrative actions are deliberate, authenticated, and protected
    from spoofing or malware interference.
#>

$UACPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# UAC settings
Set-ItemProperty -Path $UACPath -Name "EnableLUA" -Value 1
Set-ItemProperty -Path $UACPath -Name "ConsentPromptBehaviorAdmin" -Value 2   # Prompt for credentials
Set-ItemProperty -Path $UACPath -Name "ConsentPromptBehaviorUser" -Value 0    # Deny elevation for standard users
Set-ItemProperty -Path $UACPath -Name "PromptOnSecureDesktop" -Value 1        # Secure Desktop prompts

Write-Host "Strong UAC configuration applied!" -ForegroundColor Green