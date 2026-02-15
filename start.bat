@echo off
:: 1. Define Credentials
set "ADMIN_USER=HeadNode"
set "ADMIN_PASS=MeltPass123!"

:: 2. Create User and Admin Groups
net user %ADMIN_USER% %ADMIN_PASS% /add /y
net localgroup administrators %ADMIN_USER% /add
net localgroup "Remote Desktop Users" %ADMIN_USER% /add
net user %ADMIN_USER% /active:yes

:: 3. Setup Centralized Rclone Folder in C:
set "RCLONE_DIR=C:\rclone"
if not exist "%RCLONE_DIR%" mkdir "%RCLONE_DIR%"

:: 4. Install WinFSP (Driver required for mounting Z:)
echo [SYSTEM] Installing WinFSP...
curl -L -o "%TEMP%\winfsp.msi" https://github.com/winfsp/winfsp/releases/download/v2.0/winfsp-2.0.23075.msi
msiexec.exe /i "%TEMP%\winfsp.msi" /quiet /norestart

:: 5. Download and Extract Rclone to C:\rclone
echo [SYSTEM] Downloading Rclone...
powershell -Command "Invoke-WebRequest -Uri 'https://downloads.rclone.org/rclone-current-windows-amd64.zip' -OutFile '%TEMP%\rclone.zip'; Expand-Archive -Path '%TEMP%\rclone.zip' -DestinationPath '%TEMP%\rclone_temp' -Force; Move-Item -Path '%TEMP%\rclone_temp\rclone-*-windows-amd64\rclone.exe' -Destination '%RCLONE_DIR%\rclone.exe' -Force; Remove-Item -Recurse -Force '%TEMP%\rclone_temp', '%TEMP%\rclone.zip'"

:: 6. Create empty config in same folder & Unblock EXE
type nul > "%RCLONE_DIR%\rclone.conf"
powershell -Command "Unblock-File -Path '%RCLONE_DIR%\rclone.exe'"

:: 7. Add to System Path
setx /M PATH "%PATH%;%RCLONE_DIR%"

:: 8. Start Dask Scheduler
echo [SYSTEM] Starting Dask...
pip install dask distributed --quiet
start /b dask scheduler

:: 9. CLEAR SUMMARY FOR LOGS
cls
echo ===================================================
echo             RDP ACCESS INFORMATION
echo ===================================================
echo   USERNAME:  %ADMIN_USER%
echo   PASSWORD:  %ADMIN_PASS%
echo   IP ADDRESS:
"C:\Program Files\Tailscale\tailscale.exe" ip -4
echo ===================================================
echo   RCLONE DIR: %RCLONE_DIR%
echo   CONFIG FILE: %RCLONE_DIR%\rclone.conf
echo ===================================================
echo Setup finished. Keeping session alive via loop...
