# Get the directory of the current script
$currentDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Get the full path of the current script
$currentFilePath = $MyInvocation.MyCommand.Definition

Write-Host "Current script path: $currentFilePath"
Write-Host "Current script directory: $currentDir"