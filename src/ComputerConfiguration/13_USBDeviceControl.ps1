param()

<#
.SYNOPSIS
    Controls USB storage access.

.DESCRIPTION
    Blocks USB storage write and/or read access.
    Prevents data exfiltration and malware via USB.

    GPO equivalent:
    Computer Configuration ->
        Administrative Templates ->
            System ->
                Removable Storage Access
#>

$USBPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices"

# Block USB write
Set-ItemProperty -Path $USBPath -Name "Deny_Write" -Value 1 -Force

# Block USB read (optional)
# Set-ItemProperty -Path $USBPath -Name "Deny_Read" -Value 1 -Force

Write-Host "USB and removable media restrictions applied." -ForegroundColor Green
