@echo off
:: 1. Create User
net user HeadNode MeltPass123! /add /y
net localgroup administrators HeadNode /add
net localgroup "Remote Desktop Users" HeadNode /add

:: 2. Install WinFSP (The driver required for mounting Z:)
echo Installing WinFSP...
curl -L -o winfsp.msi https://github.com/winfsp/winfsp/releases/download/v2.0/winfsp-2.0.23075.msi
msiexec.exe /i winfsp.msi /quiet /norestart

:: 3. Install Rclone to C:\rclone
echo Installing Rclone...
powershell -Command "New-Item -ItemType Directory -Force -Path 'C:\rclone'; Invoke-WebRequest -Uri 'https://downloads.rclone.org/rclone-current-windows-amd64.zip' -OutFile 'C:\rclone\rclone.zip'; Expand-Archive -Path 'C:\rclone\rclone.zip' -DestinationPath 'C:\rclone\temp' -Force; Move-Item -Path 'C:\rclone\temp\rclone-*-windows-amd64\rclone.exe' -Destination 'C:\rclone\rclone.exe'; Remove-Item -Recurse -Force 'C:\rclone\temp', 'C:\rclone\rclone.zip'"

:: 4. Add Rclone to the System Path so you can type 'rclone' anywhere
setx /M PATH "%PATH%;C:\rclone"

:: 5. Install and Start Dask
echo Starting Dask Scheduler...
pip install dask distributed --quiet
start /b dask scheduler

echo ✅ SETUP COMPLETE. Rclone is installed at C:\rclone\rclone.exe
echo 🔗 Log in and run 'rclone config' to link your storage!
"C:\Program Files\Tailscale\tailscale.exe" ip -4
