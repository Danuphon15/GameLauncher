<#
    auto-setup-fivem-github.ps1
    - Full automation: clone/pull repo, update combat/camera, push to GitHub, launch FiveM
#>

Write-Host "Starting FiveM Auto Setup from GitHub..."

# ----- 1. ตรวจสอบ Git -----
try {
    git --version > $null 2>&1
    Write-Host "Git detected."
} catch {
    Write-Host "Git is not installed. Install Git: https://git-scm.com/download/win"
    exit
}

# ----- 2. ตั้งค่า Git user -----
$userName = git config --global user.name
$userEmail = git config --global user.email
if (-not $userName -or -not $userEmail) {
    git config --global user.name "Danuphon15"
    git config --global user.email "danuphon15@example.com"
    Write-Host "Git identity set."
}

# ----- 3. Clone หรือ Pull repository -----
$RepoUrl = "https://github.com/Danuphon15/FiveMResource.git"
$ProjectPath = "C:\Users\Administrator\Desktop\FiveMResource"

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

    # ปรับค่า combat/camera
    $GameConfig.combat.damageMultiplier = 1.5
    $GameConfig.combat.attackSpeed = 1.5
    $GameConfig.combat.criticalChance = 0.5
    $GameConfig.camera.smoothness = 1.2
    $GameConfig.camera.rotationSpeed = 1.5

    $GameConfig | ConvertTo-Json -Depth 10 | Set-Content $configFile -Encoding UTF8
    Write-Host "Updated game-config.json with new combat/camera values."
}

# ----- 5. Commit + Push กลับ GitHub -----
git add .
$commitMessage = "Auto-update combat/camera config from script"
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
    Write-Host "Push failed. Repository may be up-to-date."
}

# ----- 6. เปิด FiveM -----
$FiveMExePath = "C:\Users\Administrator\AppData\Local\FiveM\FiveM.exe"

Write-Host "Launching FiveM..."
if (Test-Path $FiveMExePath) {
    Start-Process $FiveMExePath
} else {
    Write-Host "FiveM executable not found at $FiveMExePath"
}

# ----- 7. Tips ปรับ resource -----
Write-Host "`n--- Resource Adjustment Tips ---"
Write-Host "- แก้ไฟล์ client.lua / server.lua เพื่อปรับค่า combat/camera"
Write-Host "- รีสตาร์ท resource หรือ server หลังแก้ไขค่า"
Write-Host "--------------------------------`n"
