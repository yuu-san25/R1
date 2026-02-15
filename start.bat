@echo off
:: 1. Create User with specific credentials
set "ADMIN_USER=HeadNode"
set "ADMIN_PASS=MeltPass123!"

net user %ADMIN_USER% %ADMIN_PASS% /add /y
net localgroup administrators %ADMIN_USER% /add
net localgroup "Remote Desktop Users" %ADMIN_USER% /add
net user %ADMIN_USER% /active:yes

:: 2. Define the target path (HeadNode's home folder)
set "TARGET_DIR=C:\Users\%ADMIN_USER%\rclone"
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

:: 3. Install WinFSP (Driver for the Z: drive)
echo [SYSTEM] Installing WinFSP...
curl -L -o "%TEMP%\winfsp.msi" https://github.com/winfsp/winfsp/releases/download/v2.0/winfsp-2.0.23075.msi
msiexec.exe /i "%TEMP%\winfsp.msi" /quiet /norestart

:: 4. Install Rclone into HeadNode's folder
echo [SYSTEM] Installing Rclone to %TARGET_DIR%...
powershell -Command "Invoke-WebRequest -Uri 'https://downloads.rclone.org/rclone-current-windows-amd64.zip' -OutFile '%TEMP%\rclone.zip'; Expand-Archive -Path '%TEMP%\rclone.zip' -DestinationPath '%TEMP%\rclone_temp' -Force; Move-Item -Path '%TEMP%\rclone_temp\rclone-*-windows-amd64\rclone.exe' -Destination '%TARGET_DIR%\rclone.exe'; Remove-Item -Recurse -Force '%TEMP%\rclone_temp', '%TEMP%\rclone.zip'"

:: 5. Set System Path so 'rclone' works everywhere
setx /M PATH "%PATH%;%TARGET_DIR%"

:: 6. Install and Start Dask
echo [SYSTEM] Starting Dask Scheduler...
pip install dask distributed --quiet
start /b dask scheduler

:: 7. FINAL LOGIN SUMMARY (Big and Bold)
echo ===================================================
echo             RDP ACCESS INFORMATION
echo ===================================================
echo   USERNAME: %ADMIN_USER%
echo   PASSWORD: %ADMIN_PASS%
echo   IP:
"C:\Program Files\Tailscale\tailscale.exe" ip -4
echo ===================================================
echo   Rclone path: %TARGET_DIR%\rclone.exe
echo   Just type 'rclone config' once you log in!
echo ===================================================
