# =============================
# [1-1] Account & Password Policy
# =============================

function Enable-PasswordComplexity {
    Write-Host "`n[+] Enabling password complexity requirement..." -ForegroundColor Cyan

    $tempCfg = Join-Path $env:TEMP "secpol_$(Get-Random).inf"

    try {
        # Export current security policy
        secedit.exe /export /cfg $tempCfg /areas SECURITYPOLICY | Out-Null

        $content = Get-Content $tempCfg

        if ($content -notmatch '^PasswordComplexity') {
            # If the line doesn't exist, append it
            $content += 'PasswordComplexity = 1'
        }
        else {
            # If it exists, force it to 1
            $content = $content -replace '^PasswordComplexity\s*=\s*\d+', 'PasswordComplexity = 1'
        }

        # secedit expects Unicode
        $content | Set-Content $tempCfg -Encoding Unicode

        # Apply the updated policy
        secedit.exe /configure `
            /db "$env:SystemRoot\security\Database\secedit.sdb" `
            /cfg $tempCfg `
            /areas SECURITYPOLICY `
            /quiet

        Write-Host "[+] Password complexity enabled." -ForegroundColor Green
    }
    catch {
        Write-Host "[!] Failed to enable password complexity: $($_.Exception.Message)" -ForegroundColor Red
    }
    finally {
        if (Test-Path $tempCfg) {
            Remove-Item $tempCfg -Force
        }
    }
}
function Set-AccountLockoutDuration {
    param(
        [int]$Minutes = 15
    )

    Write-Host "`n[+] Setting account lockout duration to $Minutes minutes..." -ForegroundColor Cyan
    try {
        net accounts /lockoutduration:$Minutes | Out-Null
        Write-Host "[+] Account lockout duration configured." -ForegroundColor Green
    }
    catch {
        Write-Host "[!] Failed to set lockout duration: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Set-AccountLockoutThreshold {
    param(
        [int]$Attempts = 5
    )

    Write-Host "`n[+] Setting account lockout threshold to $Attempts invalid logon attempts..." -ForegroundColor Cyan
    try {
        net accounts /lockoutthreshold:$Attempts | Out-Null
        Write-Host "[+] Account lockout threshold configured." -ForegroundColor Green
    }
    catch {
        Write-Host "[!] Failed to set lockout threshold: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Show-CurrentAccountPolicy {
    Write-Host "`n[Current Account Policy]" -ForegroundColor Cyan
    net accounts
    Write-Host ""
}

function Apply-AccountPasswordBaseline {
    Write-Host "`n[+] Applying Account & Password Policy baseline..." -ForegroundColor Cyan

    Enable-PasswordComplexity
    Set-AccountLockoutThreshold -Attempts 5
    Set-AccountLockoutDuration  -Minutes 15

    Write-Host "`n[+] Baseline applied. Current account policy:" -ForegroundColor Cyan
    Show-CurrentAccountPolicy

    Write-Host "`n[INFO] A logoff/logon (or reboot) may be required for some tools to show updated values." -ForegroundColor Yellow
}

# =============================
# Menu: Account & Password Policy
# =============================
function Show-AccountPasswordPolicy {

    do {
        Clear-Host
        Write-Host "[1-1] Account & Password Policy" -ForegroundColor Green
        Write-Host "--------------------------------"
        Write-Host "1) Enable password complexity"
        Write-Host "2) Configure account lockout duration"
        Write-Host "3) Configure account lockout threshold"
        Write-Host "4) Apply all account & password policy settings"
        Write-Host "5) Show current account policy"
        Write-Host "0) Back to Computer Configuration menu"
        Write-Host ""

        $apChoice = Read-Host "Select an option"

        switch ($apChoice) {
            '1' {
                Enable-PasswordComplexity
                Read-Host "`nPress ENTER to return to the Account & Password Policy menu" | Out-Null
            }
            '2' {
                $minutes = Read-Host "Enter lockout duration in minutes (e.g. 15)"

                $isValid = $true
                try {
                    [int]$minutesValue = [int]$minutes
                }
                catch {
                    $isValid = $false
                }

                if ($isValid -and $minutesValue -ge 0) {
                    Set-AccountLockoutDuration -Minutes $minutesValue
                }
                else {
                    Write-Host "Invalid input. Lockout duration must be a non-negative number." -ForegroundColor Red
                }

                Read-Host "`nPress ENTER to return to the Account & Password Policy menu" | Out-Null
            }
            '3' {
                $attempts = Read-Host "Enter lockout threshold (number of invalid logon attempts, e.g. 5)"

                $isValid = $true
                try {
                    [int]$attemptsValue = [int]$attempts
                }
                catch {
                    $isValid = $false
                }

                if ($isValid -and $attemptsValue -gt 0) {
                    Set-AccountLockoutThreshold -Attempts $attemptsValue
                }
                else {
                    Write-Host "Invalid input. Threshold must be a positive number." -ForegroundColor Red
                }

                Read-Host "`nPress ENTER to return to the Account & Password Policy menu" | Out-Null
            }
            '4' {
                Apply-AccountPasswordBaseline
                Read-Host "`nPress ENTER to return to the Account & Password Policy menu" | Out-Null
            }
            '5' {
                Show-CurrentAccountPolicy
                Read-Host "Press ENTER to return to the Account & Password Policy menu" | Out-Null
            }
            '0' {
                # just exit the loop and return to Computer Configuration menu
            }
            default {
                Write-Host "Invalid selection. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
    while ($apChoice -ne '0')
}