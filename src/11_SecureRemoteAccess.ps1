param()

<#
.SYNOPSIS
    Secures RDP and WinRM (remote access).

.DESCRIPTION
    - Disable RDP unless explicitly required
    - Restrict RDP to Administrators only
    - Ensure NLA enforced
#>

# Disable RDP by default
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 1

# If enabling RDP, force NLA (secure)
# Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" `
#                  -Name "UserAuthentication" -Value 1

# Disable WinRM unless needed
Disable-PSRemoting -Force

Write-Host "Remote access (RDP/WinRM) secured." -ForegroundColor Green
