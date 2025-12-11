param()

<#
.SYNOPSIS
    Enables BitLocker on the OS drive with TPM.

.DESCRIPTION
    Encrypts C: using TPM protection.
    Stores the recovery key in a local folder if needed.

    REQUIREMENTS:
    - Windows 10/11 Pro or Enterprise
    - TPM 1.2/2.0
#>

$RecoveryPath = "$PSScriptRoot\..\logs\BitLockerRecoveryKey.txt"

Write-Host "Enabling BitLocker on C: drive..." -ForegroundColor Cyan

Enable-BitLocker -MountPoint "C:" -EncryptionMethod XtsAes256 `
    -UsedSpaceOnly `
    -TpmProtector `
    -RecoveryPasswordProtector `
    -RecoveryKeyPath (Split-Path $RecoveryPath)

(Get-BitLockerVolume -MountPoint "C:").KeyProtector | Out-File $RecoveryPath

Write-Host "BitLocker enabled. Recovery key saved to logs folder." -ForegroundColor Green
