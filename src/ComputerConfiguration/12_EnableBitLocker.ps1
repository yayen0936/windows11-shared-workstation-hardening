param()

<#
.SYNOPSIS
    Enables BitLocker on the OS drive with TPM.

.DESCRIPTION
    Encrypts C: using TPM protection.
    Adds a Recovery Password protector (48-digit key) and saves it to the repo root \logs folder.

    REQUIREMENTS:
    - Windows 10/11 Pro or Enterprise
    - TPM 1.2/2.0
#>

$ErrorActionPreference = 'Stop'

# Script location: <repo>\src\ComputerConfiguration
# Repo root is two levels up: <repo>\
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path

# Logs must be saved under: <repo>\logs
$LogDir = Join-Path $ProjectRoot "logs"
if (-not (Test-Path $LogDir)) {
    New-Item -Path $LogDir -ItemType Directory -Force | Out-Null
}

$RecoveryPath = Join-Path $LogDir "BitLockerRecoveryKey.txt"
$MountPoint   = "C:"

try {
    Write-Host "Enabling BitLocker on C: drive..." -ForegroundColor Cyan

    $blv = Get-BitLockerVolume -MountPoint $MountPoint

    # Enable with TPM protector only (avoid ambiguous parameter sets)
    if ($blv.VolumeStatus -eq 'FullyDecrypted') {
        Enable-BitLocker -MountPoint $MountPoint -EncryptionMethod XtsAes256 `
            -UsedSpaceOnly `
            -TpmProtector `
            -ErrorAction Stop
    }

    # Ensure Recovery Password protector exists (add if missing)
    $blv = Get-BitLockerVolume -MountPoint $MountPoint
    $rp  = $blv.KeyProtector | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' } | Select-Object -First 1

    if (-not $rp) {
        Add-BitLockerKeyProtector -MountPoint $MountPoint -RecoveryPasswordProtector -ErrorAction Stop | Out-Null
        $blv = Get-BitLockerVolume -MountPoint $MountPoint
        $rp  = $blv.KeyProtector | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' } | Select-Object -First 1
    }

    # Save only the relevant recovery details to the log file
    @"
ComputerName: $env:COMPUTERNAME
Drive: $MountPoint
Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
VolumeStatus: $($blv.VolumeStatus)
ProtectionStatus: $($blv.ProtectionStatus)
RecoveryPassword: $($rp.RecoveryPassword)
KeyProtectorId: $($rp.KeyProtectorId)
"@ | Out-File -FilePath $RecoveryPath -Encoding utf8 -Force

    Write-Host "BitLocker enabled/configured. Recovery key saved to logs folder." -ForegroundColor Green
}
catch {
    Write-Error $_
    exit 1
}
