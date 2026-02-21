# PowerShell Script auto kill launcher

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


# Fungsi untuk mengecek apakah proses dengan nama tertentu sedang berjalan
function Is-ProcessRunning {
    param([string]$ProcessName)
    $ProcessNameArray=$ProcessName.Split(",")
    foreach ($ProcessItem in $ProcessNameArray) {
        if(Get-Process -Name "$ProcessItem" -ErrorAction SilentlyContinue) {
            return Get-Process -Name "$ProcessItem" -ErrorAction SilentlyContinue
        }
    }
    return $false
}

function Kill-Process {
    param([string]$ProcessName)
    return Is-ProcessRunning -ProcessName "$ProcessName" | Stop-Process -Force
}
function KillIt {
    param(
        [string]$KillExe,
        [string]$GameExeName,
        [int]$sleepTime
    )
    $GameExeNameArray=$GameExeName.Split(",")
    $KillExeArray=$KillExe.Split(",")
    # while (-not (Is-ProcessRunning -ProcessName "$GameExeName")) {
    #     while (-not (Is-ProcessRunning -ProcessName "$KillExe")) {
    #         return
    #     }
    #     Start-Sleep -Seconds $sleepTime
    # }
    $Doloop=$true
    while($Doloop){
        foreach ($GameItem in $GameExeNameArray) {
            if ((Is-ProcessRunning -ProcessName "$GameItem")) {
                foreach ($KillLauncher in $KillExeArray) {
                    if ((Is-ProcessRunning -ProcessName "$KillLauncher")) {
                        Kill-Process -ProcessName "$KillLauncher"
                        $Doloop=$false
                    } else {
                        if (-not (Is-ProcessRunning -ProcessName "$KillLauncher")) {
                            $Doloop=$false
                        }
                    }
                }
            }
        }
        Start-Sleep -Seconds $sleepTime
    }
    # Kill launcher setelah game kebuka
    # Kill-Process -ProcessName "$KillExe"
    return
}
Start-Sleep -Seconds 30

if ((Is-ProcessRunning -ProcessName "Games")) {
    KillIt -KillExe "Games" -GameExeName "Endfield" -sleepTime 10
} elseif ((Is-ProcessRunning -ProcessName "launcher_main")) {
    KillIt -KillExe "launcher_main" -GameExeName "Wuthering Waves" -sleepTime 10
} elseif ((Is-ProcessRunning -ProcessName "nikke_launcher")) {
    KillIt -KillExe "nikke_launcher" -GameExeName "nikke" -sleepTime 300
} elseif ((Is-ProcessRunning -ProcessName "HYP,HYPHelper")) {
    KillIt -KillExe "HYP,HYPHelper" -GameExeName "ZenlessZoneZero,BH3,StarRail,GenshinImpact" -sleepTime 10
}
exit 0

# if (Is-ProcessRunning -ProcessName "Games") {
#     $KillExe  = "Games"
#     $GameExeName  = "Endfield"
#     $sleepTime = 10
# } elseif (Is-ProcessRunning -ProcessName "launcher_main") {
#     $KillExe  = "launcher_main"
#     $GameExeName  = "Wuthering Waves"
#     $sleepTime = 10
# } elseif (Is-ProcessRunning -ProcessName "nikke_launcher") {
#     $KillExe  = "nikke_launcher"
#     $GameExeName  = "nikke"
#     $sleepTime = 60
# } else {
#     exit
# }

# # Tunggu sampai game benar-benar jalan
# while (-not (Is-ProcessRunning -ProcessName "$GameExeName")) {
#     Start-Sleep -Seconds 1
#     while (-not (Is-ProcessRunning -ProcessName "$KillExe")) {
#         exit
#     }
# }
# Start-Sleep -Seconds $sleepTime

# # Kill launcher setelah game kebuka first try