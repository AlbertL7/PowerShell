# Printer Fixer - Troubleshooter

## Quick Troubleshooting for Windows Printers

This powershell script was created becaue my older family would always ask me to fix the printer and I got tired of doing this process over and over again; Try turning it off and back on too.... So, what does it do.

1. Must be run with administrative privileges, checks to see if you are running as administrator.
2. Stops Printer Spool service
3. Clears the Printer Queues
4. Restarts the Printer Spool service
5. Prints a log of all activity and saves it to the Desktop in a notepad file called "PrinterFixerLog.txt". Everytime you run the script the output will be appended to that file.

- There is also a precompiled executable I made if you do not want to run your script from console.
