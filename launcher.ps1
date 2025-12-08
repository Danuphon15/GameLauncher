# === GameLauncher PRO Permanent System ===
$Core = "C:\GameLauncherCore"
$Config = "$Core\config.json"
$Loader = "$Core\load-game.ps1"

# GitHub URLs (ของคุณเอง)
$rawBase = "https://raw.githubusercontent.com/Danuphon15/GameLauncher/main"
$GitConfig = "$rawBase/config.json"
$GitLoader = "$rawBase/load-game.ps1"

# Create core folder if missing
if (!(Test-Path $Core)) { New-Item -ItemType Directory -Path $Core | Out-Null }

Write-Host "=== Updating from GitHub (PRO MODE) ==="

# Update config
try {
    Invoke-WebRequest -Uri $GitConfig -OutFile $Config -UseBasicParsing
    Write-Host "[OK] Config updated"
} catch {
    Write-Host "[ERROR] Cannot download config.json"
}

# Update loader
try {
    Invoke-WebRequest -Uri $GitLoader -OutFile $Loader -UseBasicParsing
    Write-Host "[OK] Loader updated"
} catch {
    Write-Host "[ERROR] Cannot download load-game.ps1"
}

if (!(Test-Path $Loader)) {
    Write-Host "[ERROR] Loader missing."
    exit
}

Write-Host "=== Starting FiveM with PRO settings ==="

powershell -ExecutionPolicy Bypass -File $Loader
