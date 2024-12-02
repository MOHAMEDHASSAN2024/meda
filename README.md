# Importing and Exporting Licenses in Dynamics 365 Business Central On-Premises Using PowerShell Automation

Importing and Exporting Licenses in Dynamics 365 Business Central
Introduction
https://youtu.be/Lou7oUT-Ruk
Managing licenses in Dynamics 365 Business Central On-Premises is a routine task for administrators. This PowerShell script automates the process of importing, exporting, and managing licenses, ensuring efficiency and minimizing errors.


---

Key Features of the Script

1. Setting PowerShell Execution Policy

Utilizes the command Set-ExecutionPolicy Unrestricted -Force to enable the execution of unsigned scripts.

Ensures seamless script execution but requires caution in production environments.


2. Importing the Module

The script imports the NavAdminTool module essential for managing Dynamics 365 Business Central.

Verifies if the module is available and provides guidance if not installed.


3. Restarting the Server

Automates the server instance restart using the Restart-NAVServerInstance command.

Ensures changes to the license or configuration take effect immediately.


4. Exporting License Information

Exports the license details with Export-NAVServerLicenseInformation, storing them for backup or

 audit purposes.

Provides critical details such as the license expiration date.


5. License Status Display

After exporting, the script displays key license details to the user, such as:

Expiration date.

License type.

Associated organization name.




---

Advantages of the Script

1. Ease of Use

Simplifies license management for administrators, reducing manual steps.


2. Automation of Key Tasks

Automates critical tasks such as restarting the server and exporting license information, saving time and effort.


3. Real-Time Notifications

Provides clear feedback for every operation, ensuring the user is informed about successes and failures.


4. Detailed License Monitoring

Displays accurate and essential license details to assist in proactive management.



---

Limitations of the Script

1. Potential Security Concerns

Changing the execution policy with Unrestricted can expose the environment to risks. In production, it’s safer to use RemoteSigned or equivalent policies.


2. Lack of Pre-Check for License Availability

The script assumes the license is correctly installed. If missing, export attempts will fail without detailed troubleshooting guidance.


3. Basic Error Handling

While the script provides feedback on failures, it does not offer advanced error recovery or alternative steps.


4. Manual Configuration for Execution

Administrators must manually adjust PowerShell settings and permissions for first-time setup.



---

How It Works

1. Prepare the Environment

The script adjusts PowerShell settings to allow unsigned scripts.

Imports the necessary NavAdminTool module.



2. Restart the Dynamics Server

The server instance is restarted to apply license changes.



3. Export and Display License Information

License details are exported to a file.

Key information is displayed for the administrator.



4. Feedback and Notifications

Clear, step-by-step messages keep the user informed about the script's progress.
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

#دورات_Dynamics365_باحتراف

#
