<#
    ***************************************
    Copyright Information: 
    This script was developed by:
    Mohamed Hassan
    Functional Consultant - Microsoft Dynamics 365 Business Central & LS Retail
    Techno-functional Consultant for Microsoft Dynamics 365 Business Central & LS Retail
    Phone: 01025329288
    LinkedIn: https://www.linkedin.com/in/mohamed-hassan-3158b9b1/
    YouTube: https://www.youtube.com/@Medasofit
    ***************************************
#>

Write-Host "***************************************"
Write-Host "Copyright (c) 2007-2024 Mohamed Hassan" -ForegroundColor Yellow
Write-Host "Functional Consultant - Microsoft Dynamics 365 Business Central & LS Retail" -ForegroundColor Yellow
Write-Host "Contact: 01025329288" -ForegroundColor Yellow
Write-Host "LinkedIn: https://www.linkedin.com/in/mohamed-hassan-3158b9b1/" -ForegroundColor Yellow
Write-Host "YouTube: https://www.youtube.com/@Medasofit" -ForegroundColor Yellow
Write-Host "All rights reserved." -ForegroundColor Yellow

# Import the NavAdminTool module
Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\210\Service\NavAdminTool.ps1"
Write-Host "NavAdminTool module imported successfully."

# Define Server Instance
$serverInstance = "moh"

# Restart the server instance first
try {
    Restart-NAVServerInstance -ServerInstance $serverInstance -Verbose
    Write-Host "Server instance '$serverInstance' restarted successfully."
} catch {
    Write-Host "Error restarting server instance '$serverInstance': $_"
    exit
}

# Now, Export the current license information after the restart
try {
    $licenseInfo = Export-NAVServerLicenseInformation -ServerInstance $serverInstance
    Write-Host "License information exported successfully."
} catch {
    Write-Host "Error exporting license information: $_"
    exit
}

# Check if the license info was retrieved successfully
if ($licenseInfo -ne $null) {
    # Check if ExpirationDate exists and is not null
    if ($licenseInfo.ExpirationDate -ne $null) {
        # Display the current license expiration date
        $expirationDate = $licenseInfo.ExpirationDate.ToString("M/d/yyyy")
        Write-Host "Current license expires on: $expirationDate"
    } else {
        Write-Host "Expiration date not found in the license information."
    }

    # Display all other license details
    Write-Host "License Details:"
    Write-Host $licenseInfo
} else {
    Write-Host "No license information found."-ForegroundColor Magenta
}
