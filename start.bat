@echo off
:: Create User
net user HeadNode MeltPass123! /add /y
net localgroup administrators HeadNode /add
net localgroup "Remote Desktop Users" HeadNode /add
net user HeadNode /active:yes

:: Install WinFSP (The driver that allows rclone to create a Z: drive)
echo Installing WinFSP...
curl -L -o winfsp.msi https://github.com/winfsp/winfsp/releases/download/v2.0/winfsp-2.0.23075.msi
msiexec.exe /i winfsp.msi /quiet /norestart

:: Install Rclone
echo Installing Rclone...
powershell -Command "New-Item -ItemType Directory -Force -Path 'C:\rclone'; Invoke-WebRequest -Uri 'https://downloads.rclone.org/rclone-current-windows-amd64.zip' -OutFile 'C:\rclone\rclone.zip'; Expand-Archive -Path 'C:\rclone\rclone.zip' -DestinationPath 'C:\rclone\temp' -Force; Move-Item -Path 'C:\rclone\temp\rclone-*-windows-amd64\rclone.exe' -Destination 'C:\rclone\rclone.exe'; Remove-Item -Recurse -Force 'C:\rclone\temp', 'C:\rclone\rclone.zip'"

:: Inject Rclone Config (We will pass this via GitHub Secrets)
echo %RCLONE_CONFIG_SECRET% > C:\rclone\rclone.conf

:: Start Rclone Mount as a background process (Z: Drive)
:: Note: Using --vfs-cache-mode full ensures compatibility with installers
start /b C:\rclone\rclone.exe mount mystorage: Z: --config C:\rclone\rclone.conf --vfs-cache-mode full --no-console

:: Install and Start Dask
echo Starting Dask Scheduler...
pip install dask distributed --quiet
start /b dask scheduler

echo Setup Complete!
"C:\Program Files\Tailscale\tailscale.exe" ip -4
