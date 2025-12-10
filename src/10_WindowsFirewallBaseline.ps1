param()

<#
.SYNOPSIS
    Applies a secure firewall baseline.

.DESCRIPTION
    - Enable firewall on all profiles
    - Set inbound traffic to default-deny
    - Allow only minimal outbound/inbound rules
#>

# Enable all firewall profiles
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# Default inbound = block, outbound = allow
Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultInboundAction Block
Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultOutboundAction Allow

# Allow core Windows networking (example minimal rules)
Enable-NetFirewallRule -DisplayGroup "File And Printer Sharing" -ErrorAction SilentlyContinue
Enable-NetFirewallRule -DisplayGroup "Network Discovery" -ErrorAction SilentlyContinue

Write-Host "Windows Firewall baseline applied." -ForegroundColor Green
