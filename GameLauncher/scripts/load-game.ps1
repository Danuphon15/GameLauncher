@"
# NOTE: PowerShell script ต้องรันใน PowerShell เท่านั้น

# URL ของ JSON config ของคุณบน GitHub
# แก้ไข "your-username" เป็นบัญชี GitHub ของคุณ
\$ConfigUrl = "https://raw.githubusercontent.com/your-username/GameLauncher/main/config/game-config.json"

# ดาวน์โหลด JSON config
try {
    \$ConfigContent = Invoke-WebRequest -Uri \$ConfigUrl -UseBasicParsing
    \$GameConfig = \$ConfigContent.Content | ConvertFrom-Json
    Write-Host "Loaded game config successfully!"
} catch {
    Write-Host "Failed to load game config from \$ConfigUrl"
    exit
}

# แสดงค่า config (debug)
Write-Host "Game Config:" \$GameConfig

# ตัวอย่าง path เกม (ปรับเป็น path ของคุณ)
\$GameExePath = "C:\Games\NewGame\Game.exe"

# เริ่มเกม
if (Test-Path \$GameExePath) {
    Write-Host "Launching game at \$GameExePath with loaded config..."
    Start-Process \$GameExePath
} else {
    Write-Host "Game executable not found at \$GameExePath"
}

<#
Important: Run this script only in PowerShell. Do NOT run in Python or other environments.
#>
"@ | Out-File -Encoding UTF8 scripts\load-game.ps1
