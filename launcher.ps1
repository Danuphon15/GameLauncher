# === Permanent GameLauncher ===
$CorePath = "C:\GameLauncherCore"
$ConfigPath = "$CorePath\config.json"
$LoaderPath = "$CorePath\load-game.ps1"

# สร้างโฟลเดอร์ถ้ายังไม่มี
if (!(Test-Path $CorePath)) {
    New-Item -ItemType Directory -Path $CorePath | Out-Null
}

Write-Host "=== Updating Files from GitHub ==="

# URLs จาก GitHub ของคุณ
$GitConfigURL = "https://raw.githubusercontent.com/Danuphon15/GameLauncher/main/game-config.json"
$GitLoaderURL = "https://raw.githubusercontent.com/Danuphon15/GameLauncher/main/load-game.ps1"

# ดาวน์โหลด config.json
try {
    Invoke-WebRequest -Uri $GitConfigURL -OutFile $ConfigPath -UseBasicParsing
    Write-Host "[OK] Updated config.json"
}
catch {
    Write-Host "[ERROR] Cannot download config.json"
}

# ดาวน์โหลด loader
try {
    Invoke-WebRequest -Uri $GitLoaderURL -OutFile $LoaderPath -UseBasicParsing
    Write-Host "[OK] Updated load-game.ps1"
}
catch {
    Write-Host "[ERROR] Cannot download load-game.ps1"
}

# ตรวจสอบ loader มีอยู่จริงก่อนรัน
if (!(Test-Path $LoaderPath)) {
    Write-Host "[ERROR] Loader not found at $LoaderPath"
    exit
}

Write-Host "=== Launching FiveM with Updated Settings ==="

# เรียกใช้ loader
powershell -ExecutionPolicy Bypass -File $LoaderPath
