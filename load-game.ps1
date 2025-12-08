# Load config and start FiveM
$ConfigPath = "C:\GameLauncherCore\config.json"

if (!(Test-Path $ConfigPath)) {
    Write-Host "[ERROR] Config file not found."
    exit
}

$config = Get-Content $ConfigPath | ConvertFrom-Json

Write-Host "Loaded config:"
Write-Host "Combat: $($config.combat)"
Write-Host "Camera: $($config.camera)"

Start-Process "C:\Program Files\FiveM\FiveM.exe"
