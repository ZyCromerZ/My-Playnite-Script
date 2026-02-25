
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
                #'-WindowStyle Hidden',
                '-ExecutionPolicy', 'Bypass',
                '-File', "`"$scriptPath`""
                $argString
            )        } else {
            # Relaunch PowerShell with elevation
            Start-Process powershell -Verb RunAs -ArgumentList @(
                '-NoProfile',
                #'-WindowStyle Hidden',
                '-ExecutionPolicy', 'Bypass',
                '-File', "`"$scriptPath`""
            )
        }

        exit  # Exit current non-admin session
    }
    catch {
        Write-Error "Failed to restart with admin privileges: $_"
        exit 1
    }
}

# Example: Create a scheduled task with parameters

function MakeTask {
    param(
        [string]$GameName,
        [string]$ExeDir,
        [string]$Argx,
        [bool]$UsePS
    )
    $GameNameR="$GameName"
    $GameName=$GameName.Replace(":", " ")
    if ($UsePS) {
        $Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"F:\Launcher\scripts\run-app.ps1`" `"$ExeDir`" $Argx"
    } else{
        if ($Argx) {
            $Action = New-ScheduledTaskAction -Execute "$ExeDir" -Argument "$Argx"
        } else {
            $Action = New-ScheduledTaskAction -Execute "$ExeDir"
        }
    }
    # Unregister-ScheduledTask -TaskName "$GameName" -Confirm:$false
    if ((Get-scheduledtask -TaskName "$GameName" -TaskPath "\ZyC\" -ErrorAction SilentlyContinue)) {
        Write-Host "Removing Scheduled task $GameNameR"
        Unregister-ScheduledTask -TaskName "$GameName" -TaskPath "\ZyC\" -Confirm:$false
    }
    Write-Host "Creating for " $GameNameR
    return Register-ScheduledTask -TaskName "$GameName"  -TaskPath "ZyC" -Action $Action -Description "Run $GameNameR As Admin" -RunLevel Highest
}

MakeTask -UsePS $true -ExeDir "F:\Game Online\NIKKE\Launcher\nikke_launcher.exe" -GameName "Goddess of Victory: Nikke" 
MakeTask -UsePS $true -ExeDir "F:\Game Online\ZenlessZoneZero Game\ZenlessZoneZero.exe" -GameName "Zenless Zone Zero" 
MakeTask -UsePS $true -ExeDir "F:\Game Online\GRYPHLINK\Launcher.exe" -GameName "Arknights: Endfield" 
MakeTask -UsePS $true -ExeDir "F:\Game Online\Wuthering Waves\launcher.exe" -GameName "Wuthering Waves" 
MakeTask -UsePS $true -ExeDir "F:\Game Online\Honkai Impact 3 game\BH3.exe" -GameName "Honkai Impact 3rd" 
MakeTask -UsePS $true -ExeDir "E:\Games Online\Star Rail Games\StarRail.exe" -GameName "Honkai: Star Rail" 
MakeTask -UsePS $true -ExeDir "E:\Games Online\Genshin Impact game\GenshinImpact.exe" -GameName "Genshin Impact"
MakeTask -UsePS $true -ExeDir "E:\Games\Grand Theft Auto V\PlayGTAV ini.bat" -GameName "Grand Theft Auto V" 



# $Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"F:\Launcher\scripts\kill-launcher.ps1`" "
# Unregister-ScheduledTask -TaskName "kill-launcher" -Confirm:$false
# Register-ScheduledTask -TaskName "kill-launcher"  -TaskPath "ZyC" -Action $Action -Description "Runs script with parameters" -RunLevel Highest
MakeTask -ExeDir "powershell.exe" -Argx "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"F:\Launcher\scripts\kill-launcher.ps1`" " -GameName "kill-launcher" 

$items = @("gimi", "himi", "srmi", "wwmi", "zzmi", "efmi")

# Loop through each item and print it
$xxmiPath='F:\Game Online\00-mods\FlairX Mod Manager\app\XXMI\Resources\Bin\XXMI Launcher.exe'
$xxmiPathGI='F:\Game Online\00-mods\xxmi\Resources\Bin\XXMI Launcher.exe'
foreach ($item in $items) {
    # $Action = New-ScheduledTaskAction -Execute "$xxmiPath" -Argument "--update --nogui --xxmi $item"
    # Unregister-ScheduledTask -TaskName "xxmi-$item" -Confirm:$false
    # Register-ScheduledTask -TaskName "xxmi-$item"  -TaskPath "ZyC" -Action $Action -Description "Runs script with parameters" -RunLevel Highest
    if ($item -eq "gimi") {
        MakeTask -UsePS $true -ExeDir "$xxmiPathGI" -Argx "`"--nogui --xxmi $item`"" -GameName "xxmi-$item"
    } else {
        MakeTask -UsePS $true -ExeDir "$xxmiPath" -Argx "`"--update --nogui --xxmi $item`"" -GameName "xxmi-$item"
    }
}
MakeTask -ExeDir "powershell.exe" -Argx "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"F:\Launcher\scripts\RAMMap-1.62\clear-all.ps1`"" -GameName "Ram Cleaner"
#pause