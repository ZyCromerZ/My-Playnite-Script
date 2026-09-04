# run apps
function Is-ProcessRunning {
    param([string]$ProcessName)
    Start-Sleep -Seconds 10
    while((Get-Process -Name "$ProcessName" -ErrorAction SilentlyContinue)){
        Start-Sleep -Seconds 30
    }
    return
}
$runProccess="True"
$GetModType=$args[1]
if( $GetModType ){
    if ( "$GetModType" -ne "blank" ){
        Start-ScheduledTask -TaskName "xxmi-$GetModType" -TaskPath "ZyC"
        Start-Sleep -Seconds 30
        $runProccess="False"
    }
}
$GetTypeName=$args[0]
if ($GetTypeName){

    $getClearName=$GetTypeName.Replace(":", " ")
    if ( "$runProccess" -eq "True" ){
        Start-Sleep -Seconds 1
        Start-ScheduledTask -TaskName "$getClearName" -TaskPath "ZyC"
    }
    if ("$GetTypeName" -eq "Goddess of Victory: Nikke") {
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "nikke_launcher"
        Is-ProcessRunning -ProcessName "nikke"
    } elseif ("$GetTypeName" -eq "Arknights: Endfield") {
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "Games"
        Is-ProcessRunning -ProcessName "Endfield"
    } elseif ("$GetTypeName" -eq "Wuthering Waves") {
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "launcher_main"
        Is-ProcessRunning -ProcessName "Wuthering Waves"
    } elseif ("$GetTypeName" -eq "Zenless Zone Zero") {
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "ZenlessZoneZero"
    } elseif ("$GetTypeName" -eq "Honkai Impact 3rd") {
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "BH3"
    } elseif ("$GetTypeName" -eq "Honkai: Star Rail") {
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "StarRail"
    } elseif ("$GetTypeName" -eq "Genshin Impact") {
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "GenshinImpact"
    } elseif ("$GetTypeName" -eq "Grand Theft Auto V") {
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "PlayGTAV"
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "GTA5"
    } elseif ("$GetTypeName" -eq "Neverness to Everness") {
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "NTEGlobalLauncher"
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "HTGame"
    } elseif ("$GetTypeName" -eq "SP Football Life 2026") {
        Start-Sleep -Seconds 30
        Is-ProcessRunning -ProcessName "FL_2026"
    } else {
        exit 1
    }
}
exit 0
# $ScriptPath="F:\Launcher\scripts"
# Set-Content -Path "$ScriptPath\kill.ps1" -Value "Stop-Process -Id `"$PID`" -Force" -Encoding UTF8
# Add-Content -Path "$ScriptPath\kill.ps1" -Value "Start-Sleep -Seconds 2"
# Add-Content -Path "$ScriptPath\kill.ps1" -Value "Remove-Item `"$ScriptPath\kill.ps1`" -Force"
# pause
