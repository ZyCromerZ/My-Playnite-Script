# Check if running as Administrator
$IsAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
# Get the full path of the current script
$scriptPath = $MyInvocation.MyCommand.Definition
$scriptDir = (Split-Path -Parent $scriptPath)
cd $scriptDir
if (-not $IsAdmin) {
    Write-Host "Not running as Administrator. Restarting with elevation..."
    try {
        # Get all original arguments and escape them properly
        if ($args) {
            $escapedArgs = $args | ForEach-Object { '"{0}"' -f ($_ -replace '"', '""') }
            $argString = $escapedArgs -join ' '

            # Relaunch PowerShell with elevation
            Start-Process powershell -Verb RunAs -ArgumentList @(
                '-NoProfile',
                '-WindowStyle Hidden',
                '-ExecutionPolicy', 'Bypass',
                '-File', "`"$scriptPath`""
                $argString
            ) -WindowStyle Hidden        } else {
            # Relaunch PowerShell with elevation
            Start-Process powershell -Verb RunAs -ArgumentList @(
                '-NoProfile',
                '-WindowStyle Hidden',
                '-ExecutionPolicy', 'Bypass',
                '-File', "`"$scriptPath`""
            ) -WindowStyle Hidden
        }

        exit  # Exit current non-admin session
    }
    catch {
        Write-Error "Failed to restart with admin privileges: $_"
        exit 1
    }
}
Start-Process "RAMMap.exe " -ArgumentList "-Ew"
Start-Process "RAMMap.exe " -ArgumentList "-Es"
Start-Process "RAMMap.exe " -ArgumentList "-Em"
Start-Process "RAMMap.exe " -ArgumentList "-Et"
Start-Process "RAMMap.exe " -ArgumentList "-E0"
exit 0