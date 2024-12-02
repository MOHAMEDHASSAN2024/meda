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
