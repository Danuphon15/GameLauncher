<#
    auto-setup-launcher.ps1
    Full automation for GameLauncher
#>

Write-Host "Starting GameLauncher Auto Setup..."

# ----- 1. ตรวจสอบ Git -----
try {
    git --version > $null 2>&1
    Write-Host "Git detected."
} catch {
    Write-Host "Git is not installed. Please install Git from https://git-scm.com/download/win"
    exit
}

# ----- 2. ตั้งค่า Git user ถ้ายังไม่ตั้ง -----
$userName = git config --global user.name
$userEmail = git config --global user.email
if (-not $userName -or -not $userEmail) {
    git config --global user.name "Danuphon15"
    git config --global user.email "danuphon15@example.com"
    Write-Host "Git identity set."
}

# ----- 3. ตั้งค่า path โปรเจกต์ -----
$ProjectPath = "C:\Users\Administrator\Desktop\GameLauncher"
$RepoUrl = "https://github.com/Danuphon15/GameLauncher.git"

if (!(Test-Path $ProjectPath)) {
    Write-Host "Project folder not found: $ProjectPath"
    exit
}

cd $ProjectPath

# ----- 4. Init Git repo ถ้ายังไม่มี -----
if (!(Test-Path ".git")) {
    git init
}

# ----- 5. ปรับค่าเกมใน game-config.json -----
$configFile = Join-Path $ProjectPath "config\game-config.json"

try {
    $GameConfig = Get-Content $configFile | ConvertFrom-Json
} catch {
    Write-Host "Cannot load game-config.json"
    exit
}

# ปรับค่าเกมใหม่
$GameConfig.combat.damageMultiplier = 1.5
$GameConfig.combat.attackSpeed = 1.5
$GameConfig.combat.criticalChance = 0.5
$GameConfig.camera.smoothness = 1.2
$GameConfig.camera.rotationSpeed = 1.5

$GameConfig | ConvertTo-Json -Depth 10 | Set-Content $configFile -Encoding UTF8
Write-Host "Updated game-config.json with new combat/camera values."

# ----- 6. Commit + Push -----
git add .
$commitMessage = "Auto-update game config & setup GameLauncher"
git commit -m $commitMessage -q 2>$null

$remotes = git remote
if (!($remotes -match "origin")) {
    git remote add origin $RepoUrl
}

git branch -M main

try {
    git push -u origin main
    Write-Host "Push complete!"
} catch {
    Write-Host "Failed to push to GitHub. If repo already has commits, run:"
    Write-Host "git pull origin main --allow-unrelated-histories"
}

# ----- 7. รัน loader จาก GitHub -----
$LoaderUrl = "https://raw.githubusercontent.com/Danuphon15/GameLauncher/main/scripts/load-game.ps1"

Write-Host "Running game loader from GitHub..."
try {
    iex (iwr -UseBasicParsing $LoaderUrl)
} catch {
    Write-Host "Failed to load game config from $LoaderUrl"
    exit
}

# ----- 8. เปิดเกม executable -----
$GameExePath = "C:\Games\NewGame\Game.exe"   # <-- แก้ path ให้ตรงกับเกมคุณ

if (Test-Path $GameExePath) {
    Write-Host "Launching game at $GameExePath..."
    Start-Process $GameExePath
} else {
    Write-Host "Game executable not found at $GameExePath"
}
