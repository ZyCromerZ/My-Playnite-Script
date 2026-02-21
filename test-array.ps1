$SetList="ZenlessZoneZero,BH3,StarRail,GenshinImpact,BH3+"
# $SetListArray=$SetList.Split(",")

function Test-Array {
    param([string]$GameName)
    write-host "Testing $GameName"
    $GameNameArray=$GameName.Split(",")
    while($true){
        foreach ($item in $GameNameArray) {
            if ("$item" -eq "BH3+") {
                return "stop"
            }
        }
    }
    write-host "uih iuh"
}

write-host (Test-Array -GameName "$SetList")
write-host (Test-Array -GameName "Uih")
# write-host (Test-Array -GameName "Uih,iuh")