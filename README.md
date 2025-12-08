# GameLauncher (PRO)

ไฟล์ใน repo นี้:
- launcher.ps1           : Permanent launcher (ดาวน์โหลด loader/config จาก GitHub แล้วรัน)
- scripts/load-game.ps1  : Loader ที่อ่าน config แล้วเปิด FiveM (หรือใช้ค่าที่กำหนด)
- config/game-config.json: ค่าปรับแต่ง (combat / camera / performance)

วิธีใช้งาน (บนเครื่อง):
1. ติดตั้ง Git และตั้งค่า identity:
   git config --global user.name "YourName"
   git config --global user.email "you@example.com"

2. รันสคริปต์สร้าง/ติดตั้งหรือรัน launcher:
   powershell -ExecutionPolicy Bypass -File C:\Users\Administrator\Desktop\GameLauncher\launcher.ps1

แก้ไขค่าใน config/game-config.json เพื่อปรับค่าต่าง ๆ
