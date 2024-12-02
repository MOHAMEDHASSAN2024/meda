# Importing and Exporting Licenses in Dynamics 365 Business Central On-Premises Using PowerShell Automation

Importing and Exporting Licenses in Dynamics 365 Business Central
Introduction

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
#LearnDynamics365InArabic

#Dynamics365ArabicTraining

#ProfessionalDynamics365Arabic

#ArabicDynamics365Courses

#IT4YOU_MohamedHassan

#MedaSofit_BusinessTech

#MohamedHassan_IT4YOU

#TechChannel_MedaSofit

#Dynamics365_بالعربية

#دورات_Dynamics365_باحتراف

#Dynamics365_للمحترفين_بالعربي

#IT4YOU_محمد_حسن

#MedaSofit_تكنولوجيا_الأعمال

#MOHAMED_HASSAN_IT4YOU

#قناة_التكنولوجيا_محمد_حسن




---

Recommendations for Use

Production Environments:
Use stricter execution policies like RemoteSigned and avoid modifying global settings without justification.

Error Handling:
Consider extending the script to include error logs or fallback actions for smoother troubleshooting.

Automation Scheduling:
Combine this script with task scheduling tools to perform routine license exports automatically.



---

Conclusion

This PowerShell script is an efficient tool for automating license management in Dynamics 365 Business Central On-Premises. While it simplifies the process of importing, exporting, and monitoring licenses, administrators should use it cautiously in sensitive environments, ensuring policies and permissions are securely configured.


---

Hashtags

#Dynamics365 #PowerShell #LicenseManagement #Automation #BusinessCentral #ITSupport #NavAdminTool #OnPremisesSolutions #DataSafety

$serverName = "localhost"
$databaseName = "nav21"
$backupPath = "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup"
$logFile = "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup_log.txt"
$backupHistoryFile = "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup_History.txt"
$daysToKeepBackup = 30

# 1. Checking if enough disk space is available
$drive = Get-PSDrive C
if ($drive.Free -lt 5GB) {
    Write-Host "Not enough space on the disk. Exiting the backup process."
    exit
}

# 2. Function to show last backup date
function Show-LastBackupDate {
    if (Test-Path $backupHistoryFile) {
        $lastBackup = Get-Content $backupHistoryFile | Select-Object -Last 1
        Write-Host "Last backup was on: $lastBackup"
    } else {
        Write-Host "No backup history found."
    }
}

# Show last backup info
Show-LastBackupDate

# 3. Check if database exists
$databaseExists = Invoke-Sqlcmd -Query "SELECT COUNT(*) FROM sys.databases WHERE name = '$databaseName'" -ServerInstance $serverName
if ($databaseExists -eq 0) {
    Write-Host "Database $databaseName not found. Skipping backup."
    exit
}

# 4. Generate a unique backup file name with timestamp
$dateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = "$backupPath\$databaseName-$dateTime.bak"

Write-Host "Starting backup for database $databaseName..."

# 5. Backup Database
try {
    Invoke-Sqlcmd -Query "BACKUP DATABASE [$databaseName] TO DISK = N'$backupFile' WITH COMPRESSION" -ServerInstance $serverName
    Write-Host "Backup completed successfully."
    
    # Add to backup history
    Add-Content -Path $backupHistoryFile -Value "$(Get-Date) : Backup for database $databaseName. Backup file: $backupFile"

} catch {
    $errorMessage = "Error occurred: $_"
    Add-Content -Path $logFile -Value "$(Get-Date): $errorMessage"
    Write-Host "An error occurred. Check the log file for details."
}

# 6. Delete old backups if necessary
$backupFiles = Get-ChildItem -Path $backupPath -Filter "*.bak"
foreach ($file in $backupFiles) {
    if ($file.CreationTime -lt (Get-Date).AddDays(-$daysToKeepBackup)) {
        Remove-Item $file.FullName
        Write-Host "Old backup deleted: $file"
    }
}

# Final backup status
Show-LastBackupDate


