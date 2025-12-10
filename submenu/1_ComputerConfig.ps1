# =============================
# Computer Configuration submenus
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
        Write-Host "0) Back to Computer Configuration menu"
        Write-Host ""

        $apChoice = Read-Host "Select an option"

        switch ($apChoice) {
            '1' { 
                Write-Host "TODO: Enable password complexity" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the Account & Password Policy menu" | Out-Null
            }
            '2' { 
                Write-Host "TODO: Configure account lockout duration" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the Account & Password Policy menu" | Out-Null
            }
            '3' { 
                Write-Host "TODO: Configure account lockout threshold" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the Account & Password Policy menu" | Out-Null
            }
            '4' { 
                Write-Host "TODO: Apply all account & password policy settings" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the Account & Password Policy menu" | Out-Null
            }
            '0' { }
            default {
                Write-Host "Invalid selection. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
    while ($apChoice -ne '0')
}

function Show-ComputerConfigPolicies {
    do {
        Clear-Host
        Write-Host "[Computer Configuration Policies]" -ForegroundColor Green
        Write-Host "-----------------------------------"
        Write-Host "1) Account & Password Policy"
        Write-Host "2) Local Accounts & Logon Settings"
        Write-Host "3) System Hardening & Encryption"
        Write-Host "4) Network, Firewall & Remote Access"
        Write-Host "0) Back to Main Menu"
        Write-Host ""

        $compChoice = Read-Host "Select an option"

        switch ($compChoice) {
            '1' { Show-AccountPasswordPolicy }
            '2' { 
                Write-Host "TODO: Local Accounts & Logon Settings" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the Computer Configuration menu" | Out-Null
            }
            '3' { 
                Write-Host "TODO: System Hardening & Encryption" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the Computer Configuration menu" | Out-Null
            }
            '4' { 
                Write-Host "TODO: Network, Firewall & Remote Access" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the Computer Configuration menu" | Out-Null
            }
            '0' { } 
            default {
                Write-Host "Invalid selection. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
    while ($compChoice -ne '0')
}