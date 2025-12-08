# === GameLauncher PRO loader ===
\ = Split-Path -Parent \System.Management.Automation.InvocationInfo.MyCommand.Definition
\ = Join-Path \ \"..\\config\\game-config.json\" | Resolve-Path -ErrorAction SilentlyContinue

if (-not \) {
    Write-Host \"[ERROR] config/game-config.json not found.\"
    exit 1
}

\ = Get-Content \ | ConvertFrom-Json

Write-Host \"Loaded config (combat/camera):\"
Write-Host \"  Combat: Recoil=\, AttackSpeed=\, CritChance=\\"
Write-Host \"  Camera: FOV=\, Sensitivity=\\"

# Try to apply client settings if possible
\ = \"\C:\Users\Administrator\AppData\Local\\FiveM\\FiveM.app\\data\\client\\settings.json\"
if (Test-Path (Split-Path \ -Parent)) {
    try {
        \ = @{}
        \.fov = \.camera.fov
        \.sensitivity = \.camera.sensitivity
        \.shake = \.camera.shake
        \ | ConvertTo-Json -Depth 10 | Set-Content -Path \ -Encoding UTF8
        Write-Host \"[OK] Applied camera settings to FiveM client settings (if supported)."
    } catch {
        Write-Host \"[WARN] Failed to write FiveM client settings.\"
    }
}

# Launch FiveM
\ = \.fivem_path
if (Test-Path \) {
    Start-Process -FilePath \
    Write-Host \"[OK] Launched FiveM.\"
} else {
    Write-Host \"[ERROR] FiveM executable not found at: \\"
    exit 1
}
