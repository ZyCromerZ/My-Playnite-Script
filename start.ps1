# run apps
function Is-ProcessRunning {
    param([string]$ProcessName)
    Start-Sleep -Seconds 10
    while((Get-Process -Name "$ProcessName" -ErrorAction SilentlyContinue)){
        Start-Sleep -Seconds 10
    }
    return
}

$GetModType=$args[1]
if( $GetModType ){
    if ( "$GetModType" -ne "blank" ){
        Start-ScheduledTask -TaskName "xxmi-$GetModType" -TaskPath "ZyC"
        Start-Sleep -Seconds 1
    }
}
$GetTypeName=$args[0]
if ($GetTypeName){

    $getClearName=$GetTypeName.Replace(":", " ")
    Start-Sleep -Seconds 1
    Start-ScheduledTask -TaskName "$getClearName" -TaskPath "ZyC"
    if ("$GetTypeName" -eq "Goddess of Victory: Nikke") {
        Is-ProcessRunning -ProcessName "nikke_launcher"
        Is-ProcessRunning -ProcessName "nikke"
    } elseif ("$GetTypeName" -eq "Arknights: Endfield") {
        Is-ProcessRunning -ProcessName "Games"
        Is-ProcessRunning -ProcessName "Endfield"
    } elseif ("$GetTypeName" -eq "Wuthering Waves") {
        Is-ProcessRunning -ProcessName "launcher_main"
        Is-ProcessRunning -ProcessName "Wuthering Waves"
    } elseif ("$GetTypeName" -eq "Zenless Zone Zero") {
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
