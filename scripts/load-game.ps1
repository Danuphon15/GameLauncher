# === GameLauncher PRO loader ===
$ConfigPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path -Parent) "..\\config\\game-config.json"
$ConfigPath = Resolve-Path $ConfigPath -ErrorAction SilentlyContinue

if (-not $ConfigPath) {
    Write-Host "[ERROR] config/game-config.json not found."
    exit 1
}

$config = Get-Content $ConfigPath | ConvertFrom-Json

Write-Host "Loaded config (combat/camera):"
Write-Host "  Combat: Recoil=$($config.combat.recoil), AttackSpeed=$($config.combat.attackSpeed), CritChance=$($config.combat.criticalChance)"
Write-Host "  Camera: FOV=$($config.camera.fov), Sensitivity=$($config.camera.sensitivity)"

# Example: apply client-side camera settings (if FiveM stores settings at this path)
$FiveMClientSettings = "$env:LOCALAPPDATA\FiveM\FiveM.app\data\client\settings.json"
if (Test-Path (Split-Path $FiveMClientSettings -Parent)) {
    try {
        $clientSettings = @{}
        $clientSettings.fov = $config.camera.fov
        $clientSettings.sensitivity = $config.camera.sensitivity
        $clientSettings.shake = $config.camera.shake
        $clientSettings | ConvertTo-Json -Depth 10 | Set-Content -Path $FiveMClientSettings -Encoding UTF8
        Write-Host "[OK] Applied camera settings to FiveM client settings (if supported)."
    } catch {
        Write-Host "[WARN] Failed to write FiveM client settings."
    }
}

# Launch FiveM
$FiveMExe = $config.fivem_path
if (Test-Path $FiveMExe) {
    Start-Process -FilePath $FiveMExe
    Write-Host "[OK] Launched FiveM."
} else {
    Write-Host "[ERROR] FiveM executable not found at: $FiveMExe"
    exit 1
}
