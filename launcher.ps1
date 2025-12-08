# === GameLauncher PRO Permanent Launcher ===
$Core = "C:\GameLauncherCore"
if (-not (Test-Path $Core)) { New-Item -ItemType Directory -Path $Core | Out-Null }

$rawBase = "https://raw.githubusercontent.com/Danuphon15/GameLauncher/main"
$GitConfig = "$rawBase/config/game-config.json"
$GitLoader = "$rawBase/scripts/load-game.ps1"

$localConfig = Join-Path $Core "config-game.json"
$localLoader = Join-Path $Core "load-game.ps1"

Write-Host "Updating config from $GitConfig"
try { Invoke-WebRequest -Uri $GitConfig -OutFile $localConfig -UseBasicParsing; Write-Host "[OK] config downloaded." } catch { Write-Host "[ERROR] config download failed." }

Write-Host "Updating loader from $GitLoader"
try { Invoke-WebRequest -Uri $GitLoader -OutFile $localLoader -UseBasicParsing; Write-Host "[OK] loader downloaded." } catch { Write-Host "[ERROR] loader download failed." }

if (-not (Test-Path $localLoader)) { Write-Host "[FATAL] loader missing"; exit 1 }

# Ensure config is placed where loader expects: move into a config folder
$targetConfigDir = Join-Path $Core "config"
if (-not (Test-Path $targetConfigDir)) { New-Item -ItemType Directory -Path $targetConfigDir | Out-Null }
Move-Item -Path $localConfig -Destination (Join-Path $targetConfigDir "game-config.json") -Force

# Run loader (use PowerShell with bypass)
powershell -ExecutionPolicy Bypass -File $localLoader
