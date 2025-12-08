# === GameLauncher PRO Permanent Launcher ===
\ = \"C:\GameLauncherCore\"
if (-not (Test-Path \)) { New-Item -ItemType Directory -Path \ | Out-Null }

\ = \"https://raw.githubusercontent.com/Danuphon15/GameLauncher/main\"
\ = \"\/config/game-config.json\"
\ = \"\/scripts/load-game.ps1\"

\ = Join-Path \ \"config-game.json\"
\ = Join-Path \ \"load-game.ps1\"

Write-Host \"Updating config from \\"
try { Invoke-WebRequest -Uri \ -OutFile \ -UseBasicParsing; Write-Host \"[OK] config downloaded.\" } catch { Write-Host \"[ERROR] config download failed.\" }

Write-Host \"Updating loader from \\"
try { Invoke-WebRequest -Uri \ -OutFile \ -UseBasicParsing; Write-Host \"[OK] loader downloaded.\" } catch { Write-Host \"[ERROR] loader download failed.\" }

# Ensure config is placed where loader expects
\ = Join-Path \ \"config\"
if (-not (Test-Path \)) { New-Item -ItemType Directory -Path \ | Out-Null }
Move-Item -Path \ -Destination (Join-Path \ \"game-config.json\") -Force

# Run loader
powershell -ExecutionPolicy Bypass -File \
