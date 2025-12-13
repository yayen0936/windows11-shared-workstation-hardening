param()

<#
.SYNOPSIS
    Secures RDP and WinRM (remote access).

.DESCRIPTION
    Reduces the remote access attack surface by disabling Remote Desktop
    Protocol (RDP) and Windows Remote Management (WinRM) when not required.
    By limiting or disabling remote management services, this control helps
    prevent unauthorized remote access, credential abuse, and lateral
    movement attacks on the workstation.
#>

# Disable RDP by default
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 1

# If enabling RDP, force NLA (secure)
# Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" `
#                  -Name "UserAuthentication" -Value 1

# Disable WinRM remoting
Disable-PSRemoting -Force

# Stop and disable WinRM service
Stop-Service WinRM -Force -ErrorAction SilentlyContinue
Set-Service WinRM -StartupType Disabled

Write-Host "Remote access (RDP/WinRM) secured." -ForegroundColor Green