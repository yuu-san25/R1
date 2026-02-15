@echo off
:: 1. Create User
set "ADMIN_USER=HeadNode"
set "ADMIN_PASS=MeltPass123!"
net user %ADMIN_USER% %ADMIN_PASS% /add /y
net localgroup administrators %ADMIN_USER% /add

:: 2. Setup Centralized Rclone Folder
set "RCLONE_DIR=C:\rclone"
if not exist "%RCLONE_DIR%" mkdir "%RCLONE_DIR%"

:: 3. Install WinFSP (Required for Mounting)
echo [SYSTEM] Installing WinFSP...
curl -L -o "%TEMP%\winfsp.msi" https://github.com/winfsp/winfsp/releases/download/v2.0/winfsp-2.0.23075.msi
msiexec.exe /i "%TEMP%\winfsp.msi" /quiet /norestart

:: 4. Download Rclone and move to C:\rclone
echo [SYSTEM] Downloading Rclone...
powershell -Command "Invoke-WebRequest -Uri 'https://downloads.rclone.org/rclone-current-windows-amd64.zip' -OutFile '%TEMP%\rclone.zip'; Expand-Archive -Path '%TEMP%\rclone.zip' -DestinationPath '%TEMP%\rclone_temp' -Force; Move-Item -Path '%TEMP%\rclone_temp\rclone-*-windows-amd64\rclone.exe' -Destination '%RCLONE_DIR%\rclone.exe' -Force; Remove-Item -Recurse -Force '%TEMP%\rclone_temp', '%TEMP%\rclone.zip'"

:: 5. Create an empty rclone.conf in the same folder if it doesn't exist
if not exist "%RCLONE_DIR%\rclone.conf" type nul > "%RCLONE_DIR%\rclone.conf"

:: 6. Unblock the EXE to prevent permission popups
powershell -Command "Unblock-File -Path '%RCLONE_DIR%\rclone.exe'"

:: 7. Update System Path
setx /M PATH "%PATH%;%RCLONE_DIR%"

:: 8. Start Dask
echo [SYSTEM] Starting Dask Scheduler...
pip install dask distributed --quiet
start /b dask scheduler

echo ===================================================
echo SETUP COMPLETE!
echo Location: %RCLONE_DIR%
echo Config:   %RCLONE_DIR%\rclone.conf
echo ===================================================
"C:\Program Files\Tailscale\tailscale.exe" ip -4
