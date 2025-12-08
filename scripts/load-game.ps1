# === FiveM PRO Loader ===

$ConfigPath = "C:\GameLauncherCore\config.json"

if (!(Test-Path $ConfigPath)) {
    Write-Host "[ERROR] Config file missing."
    exit
}

$config = Get-Content $ConfigPath | ConvertFrom-Json

# Show settings
Write-Host "Combat Boost: Recoil=$($config.combat.recoil), Spread=$($config.combat.spread)"
Write-Host "Camera FOV: $($config.camera.fov) Sensitivity: $($config.camera.sensitivity)"

# OPTIONAL: inject settings into FiveM config
$FiveMAppData = "$env:LOCALAPPDATA\FiveM\FiveM.app\data\client\settings.json"

if (Test-Path $FiveMAppData) {
    $clientSettings = @{
        "fov" = $config.camera.fov
        "sensitivity" = $config.camera.sensitivity
        "shake" = $config.camera.shake
    } | ConvertTo-Json -Depth 10

    Set-Content -Path $FiveMAppData -Value $clientSettings -Force
    Write-Host "[OK] Applied camera settings"
}

# Launch FiveM
$FiveM = "C:\Program Files\FiveM\FiveM.exe"
if (Test-Path $FiveM) {
    Start-Process $FiveM
    Write-Host "[OK] FiveM started"
} else {
    Write-Host "[ERROR] FiveM.exe not found."
}
