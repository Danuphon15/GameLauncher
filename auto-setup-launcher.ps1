# ================================
# Auto Setup + Git Push + Run Loader
# ================================

Write-Host "Starting GameLauncher Auto Setup..."

# ตรวจสอบ Git ก่อน
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is NOT installed. Please install Git from https://git-scm.com/downloads"
    exit
}

Write-Host "Git detected."

# Path โปรเจกต์
$projectPath = "C:\Users\Administrator\Desktop\GameLauncher"

if (-not (Test-Path $projectPath)) {
    Write-Host "Project folder not found: $projectPath"
    exit
}

cd $projectPath

# ตรวจสอบ .git
if (-not (Test-Path "$projectPath\.git")) {
    git init
    git branch -M main
}

# ตั้งค่า Git identity
git config --global user.name "Danuphon15"
git config --global user.email "danuphon15@example.com"

# สร้าง config ใหม่ตามค่าที่คุณต้องการ
$ConfigPath = "$projectPath\config\game-config.json"

$ConfigContent = @{
    Combat = @{
        EasyHit = $true
        CritBoost = 2.0
        HeadshotAssist = 1.5
    }
    Camera = @{
        SmoothTurn = $true
        TurnSpeed = 1.8
        MotionStability = $true
    }
} | ConvertTo-Json -Depth 10

Set-Content -Path $ConfigPath -Value $ConfigContent -Encoding UTF8

Write-Host "Updated game-config.json with new combat/camera values."

# Git push อัตโนมัติ
git add .
git commit -m "Auto-update game config + auto push"
git remote add origin https://github.com/Danuphon15/GameLauncher.git 2>$null
git push -u origin main

Write-Host "Push complete!"

# รัน loader จาก GitHub
$LoaderUrl = "https://raw.githubusercontent.com/Danuphon15/GameLauncher/main/scripts/load-game.ps1"

Write-Host "Running game loader from GitHub..."
iex (iwr -UseBasicParsing $LoaderUrl)

Write-Host "Automation Complete."
