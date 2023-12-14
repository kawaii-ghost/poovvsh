Write-Host "poovvsh v1.0-Beta"

# Get the total amount of RAM and PageFile
$totalRAM =  [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1MB)
# $totalPageFile =  (Get-CimInstance -Class Win32_PageFileUsage -ComputerName $Computer).AllocatedBaseSize
Write-Host "mem total:" $totalRAM "MiB" #pagefile total:" $totalPageFile

# Set the threshold for free RAM
$threshold = 0.36e9 / 1MB

# Run an infinite loop
while ($true) {
    # Get the current amount of free RAM
    $freeRAM =  [math]::Round((Get-WmiObject -Class Win32_OperatingSystem).FreePhysicalMemory / 1KB)
    #$freePageFile = $totalPageFile - (Get-CimInstance -Class Win32_PageFileUsage -ComputerName $Computer).CurrentUsage

    # Calculate the free RAM and PageFile percentage
    $freeRAMPercent = [math]::Round(($freeRAM / $totalRAM) * 100)
    #$freePageFilePercent = [math]::Round(($freePageFile / $totalPageFile) * 100)

    Write-Host "mem avail:" $freeRAM "of" $totalRAM "MB (" $freeRAMPercent "%)" #, pagefile free:" $freePageFile "of" $totalPageFile "MB (" $freePageFilePercent "%)"
  # Check if the free RAM is below the threshold
    if ($freeRAM -lt $threshold ) {#-and $freePageFile -lt $threshold) {
        # Get the process that is using the most memory
        $highMemProcess = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 1
        
        # Kill the process and force it to close
        Stop-Process -Id $highMemProcess.Id

        # Write a message to the console and send notification
        $Date = Get-Date
        $Message = "Killed process $($highMemProcess.Name) with PID $($highMemProcess.Id) for using too much memory"
        Write-Host $Date "`t" $Message
        New-BurntToastNotification -Text $Message
    }

    # Wait for one second before repeating the loop 
    Start-Sleep -Seconds 1
}
