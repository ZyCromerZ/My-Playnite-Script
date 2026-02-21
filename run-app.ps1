
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
            Start-Process powershell -WindowStyle Hidden -Verb RunAs -ArgumentList @(
                '-NoProfile',
                '-WindowStyle Hidden',
                '-ExecutionPolicy', 'Bypass',
                '-File', "`"$scriptPath`""
                $argString
            ) -WindowStyle Hidden        } else {
            # Relaunch PowerShell with elevation
            Start-Process powershell -WindowStyle Hidden -Verb RunAs -ArgumentList @(
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
# args = path to executable
if ($args){
    $GetExe=$args[0]
    $GetArgs=$args[1]
    if($GetArgs){
        Start-Process "$GetExe" -ArgumentList "$GetArgs"
    } else {
        Start-Process "$GetExe"
    }
    Write-Host $args
    exit 0
} else {
    Write-Host "No arguments provided"
    exit 1
}