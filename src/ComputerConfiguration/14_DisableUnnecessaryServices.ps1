param()

<#
.SYNOPSIS
    Disables insecure or unnecessary Windows services.

.DESCRIPTION
    Example stops:
    - RemoteRegistry
    - SSDP Discovery
    - UPnP Device Host
#>

$ServicesToDisable = @(
    "RemoteRegistry",
    "SSDPSRV",
    "upnphost"
)

foreach ($svc in $ServicesToDisable) {
    Write-Host "Disabling service: $svc"
    Stop-Service $svc -Force -ErrorAction SilentlyContinue
    Set-Service $svc -StartupType Disabled -ErrorAction SilentlyContinue
}

Write-Host "Unnecessary services disabled." -ForegroundColor Green
