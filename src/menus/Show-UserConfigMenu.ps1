# =============================
# User Configuration submenu
# =============================

function Show-UserConfigMenu {
    do {
        Clear-Host
        Write-Host "[User Configuration Policies]" -ForegroundColor Green
        Write-Host "-----------------------------------"
        Write-Host "1) Session Lock & Screensaver"
        Write-Host "2) Control Panel & Settings Restrictions"
        Write-Host "3) Software Installation Restrictions"
        Write-Host "0) Back to Main Menu"
        Write-Host ""

        $userChoice = Read-Host "Select an option"

        switch ($userChoice) {
            '1' { 
                Write-Host "TODO: Configure session lock & screensaver settings" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the User Configuration menu" | Out-Null
            }
            '2' { 
                Write-Host "TODO: Configure Control Panel & Settings restrictions" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the User Configuration menu" | Out-Null
            }
            '3' { 
                Write-Host "TODO: Configure software installation restrictions" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the User Configuration menu" | Out-Null
            }
            '0' { } 
            default {
                Write-Host "Invalid selection. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
    while ($userChoice -ne '0')
}