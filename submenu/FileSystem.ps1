# =============================
# File System & Data Access submenu
# =============================

function Show-FileSystem {
    do {
        Clear-Host
        Write-Host "[File System & Data Access Controls]" -ForegroundColor Green
        Write-Host "-----------------------------------"
        Write-Host "1) Set NTFS permissions role-based local groups"
        Write-Host "2) Remove inheritance"
        Write-Host "3) Remove propagation"
        Write-Host "4) Remove SMB shares"
        Write-Host "0) Back to Main Menu"
        Write-Host ""

        $fsChoice = Read-Host "Select an option"

        switch ($fsChoice) {
            '1' { 
                Write-Host "TODO: Set NTFS permissions using role-based local groups" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the File System menu" | Out-Null
            }
            '2' { 
                Write-Host "TODO: Remove inheritance on selected folders" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the File System menu" | Out-Null
            }
            '3' { 
                Write-Host "TODO: Remove propagation / adjust advanced ACL propagation" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the File System menu" | Out-Null
            }
            '4' { 
                Write-Host "TODO: Remove SMB shares for SecurePro data folders" -ForegroundColor Yellow
                Read-Host "Press ENTER to return to the File System menu" | Out-Null
            }
            '0' { } # Back
            default {
                Write-Host "Invalid selection. Please try again." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
    while ($fsChoice -ne '0')
}