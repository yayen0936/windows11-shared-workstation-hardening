param()

<#
.SYNOPSIS
    Configures secure logon behavior.

.DESCRIPTION
    Implements:
    - CTRL+ALT+DEL required
    - Hide last logged-on username
    - Legal logon banner
#>

# Registry Paths
$SecOptions = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

Set-ItemProperty -Path $SecOptions -Name "DisableCAD" -Value 0                 # Require CTRL+ALT+DEL
Set-ItemProperty -Path $SecOptions -Name "DontDisplayLastUserName" -Value 1   # Hide last username

# Legal Banner
Set-ItemProperty -Path $SecOptions -Name "LegalNoticeCaption" -Value "Authorized Access Only"
Set-ItemProperty -Path $SecOptions -Name "LegalNoticeText" -Value "Use of this workstation is restricted to authorized personnel."

Write-Host "Secure logon options applied successfully!" -ForegroundColor Green
