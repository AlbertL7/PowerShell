# Get the current user's desktop path
$desktopPath = [Environment]::GetFolderPath("Desktop")

# Define the output file name and path
$outputFileName = "PrinterFixerLog.txt"
$outputFilePath = Join-Path -Path $desktopPath -ChildPath $outputFileName

# Use Out-File with -Append to add content to the file
"`nStarting Printer Troubleshooting Script at: $(Get-Date)" | Out-File -FilePath $outputFilePath -Append

# Check if the script is running as an Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relaunch the script with administrator rights
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Exit
}

# Stop the Print Spooler service and log the action
function Stop-SpoolerService {
    try {
        Stop-Service -Name "Spooler" -Force -ErrorAction Stop
        "Print Spooler Service stopped successfully." | Out-File -FilePath $outputFilePath -Append
    } catch {
        "Failed to stop Print Spooler Service: $_" | Out-File -FilePath $outputFilePath -Append
    }
}

# Start the Print Spooler service and log the action
function Start-SpoolerService {
    try {
        Start-Service -Name "Spooler" -ErrorAction Stop
        "Print Spooler Service started successfully." | Out-File -FilePath $outputFilePath -Append
    } catch {
        "Failed to start Print Spooler Service: $_" | Out-File -FilePath $outputFilePath -Append
    }
}

# Clear print queues for all printers and log the action
function Clear-PrintQueues {
    $spoolFolder = "$env:SystemRoot\System32\spool\PRINTERS"
    try {
        Stop-SpoolerService
        Get-ChildItem -Path $spoolFolder -ErrorAction Stop | Remove-Item -Force
        "Print queues cleared successfully." | Out-File -FilePath $outputFilePath -Append
    } catch {
        "Error clearing print queues: $_" | Out-File -FilePath $outputFilePath -Append
    } finally {
        Start-SpoolerService
    }
}

# Log running with administrator privileges
"***Script is running with administrator privileges***" | Out-File -FilePath $outputFilePath -Append

# List all printers and write their names to the output file
"Found Printers:" | Out-File -FilePath $outputFilePath -Append
Get-Printer | ForEach-Object {
    "`t($_.Name)" | Out-File -FilePath $outputFilePath -Append
}

# Attempting to clear print queues for all printers
Clear-PrintQueues

# Final message indicating the script's completion
"Printer troubleshooting process completed." | Out-File -FilePath $outputFilePath -Append

"Script completed at: $(Get-Date)" | Out-File -FilePath $outputFilePath -Append
Start-Sleep -Seconds 1
Start-Process notepad.exe -ArgumentList $outputFilePath
