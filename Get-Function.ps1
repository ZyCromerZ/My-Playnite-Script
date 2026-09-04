function KillService {
	param(
		[string]$ProcessName
	)

	$servicee = Get-ScheduledTask -TaskName "$ProcessName" -ErrorAction SilentlyContinue
	if ($servicee.State -eq 'Running' ) {
		Stop-ScheduledTask -TaskName "$ProcessName" -TaskPath "\ZyC\"

	}
}

function WaitService {
	param(
		[string]$ProcessName
	)
	$DoLoop = 'true'
	while ($DoLoop -eq 'true' ){
		$servicee = Get-ScheduledTask -TaskName "$ProcessName" -TaskPath \"ZyC\" -ErrorAction SilentlyContinue
		Write-Host $servicee.State
		if ($servicee.State -eq 'Running' ) {
			Start-Sleep -Seconds 1
		} else {
			$DoLoop = 'false'
			return
		}
	}
}

function RunService {
	param(
		[string]$ProcessName
	)

	$servicee = Get-ScheduledTask -TaskName "$ProcessName" -TaskPath \"ZyC\" -ErrorAction SilentlyContinue
	if ($servicee.State -eq 'Ready' ) {
		Start-ScheduledTask -TaskName "$ProcessName" -TaskPath "\ZyC\"
	}
}	