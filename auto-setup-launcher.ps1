<#
    auto-setup-full-launcher.ps1
    Full automation: update config, push GitHub, launch GameLauncher
#>

Write-Host "Starting GameLauncher Full Auto Setup..."

# ----- 1. ตรวจสอบ Git -----
try {
    git --version > $null 2>&1
    Write-Host "Git detected."
} catch {
    Write-Host "Git is not installed. Install Git: https://git-scm.com/download/win"
    exit
}

# ----- 2. ตั้งค่า Git identity -----
$userName = git config --global user.name
$userEmail = git config --global user.email
if (-not $userName -or -not $userEmail) {
    git config --global user.name "Danuphon15"
    git config --global user.email "danuphon15@example.com"
    Write-Host "Git identity set."
}

# ----- 3. ตั้งค่า path ของ GameLauncher -----
$ProjectPath = "C:\Users\Administrator\Desktop\GameLauncher"
$RepoUrl = "https://github.com/Danuphon15/GameLauncher.git"

if (!(Test-Path $ProjectPath)) {
    Write-Host "Cloning repository..."
    git clone $RepoUrl $ProjectPath
} else {
    Write-Host "Repository exists. Pulling latest changes..."
    cd $ProjectPath
    git pull
}

cd $ProjectPath

# ----- 4. โหลดและปรับค่า config -----
$configFile = Join-Path $ProjectPath "config\game-config.json"
if (Test-Path $configFile) {
    try {
        $GameConfig = Get-Content $configFile | ConvertFrom-Json
    } catch {
        Write-Host "Cannot load game-config.json"
    }

    # ปรับค่าเกมให้ตีเข้ามุมง่าย / ไม้ออกไว / ฟิลสมูท
    $GameConfig.combat.damageMultiplier = 1.5
    $GameConfig.combat.attackSpeed = 1.5
    $GameConfig.combat.criticalChance = 0.5
    $GameConfig.camera.smoothness = 1.2
    $GameConfig.camera.rotationSpeed = 1.5

    $GameConfig | ConvertTo-Json -Depth 10 | Set-Content $configFile -Encoding UTF8
    Write-Host "Updated game-config.json with enhanced combat/camera values."
}

# ----- 5. Commit + Push กลับ GitHub -----
git add .
$commitMessage = "Auto-update config from full launcher script"
git commit -m $commitMessage -q 2>$null

$remotes = git remote
if (!($remotes -match "origin")) {
    git remote add origin $RepoUrl
}

git branch -M main

try {
    git push -u origin main
    Write-Host "Push to GitHub complete!"
} catch {
    Write-Host "Push failed. Repository may already be up-to-date."
}

# ----- 6. รัน loader ของ GameLauncher -----
$LoaderUrl = "https://raw.githubusercontent.com/Danuphon15/GameLauncher/main/scripts/load-game.ps1"
Write-Host "Running GameLauncher loader from GitHub..."
try {
    iex (iwr -UseBasicParsing $LoaderUrl)
} catch {
    Write-Host "Failed to run loader from GitHub. Check that load-game.ps1 exists in repository."
}

# ----- 7. Tips -----
Write-Host "`n--- Tips ---"
Write-Host "- สามารถปรับค่าเพิ่มเติมใน config/game-config.json"
Write-Host "- Loader จะรันเกมตาม path ที่ตั้งไว้ใน load-game.ps1"
Write-Host "----------------`n"
