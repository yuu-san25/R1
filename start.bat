@echo off
:: Create a new user with a stronger password
net user HeadNode MeltPass123! /add /y
net localgroup administrators HeadNode /add
net localgroup "Remote Desktop Users" HeadNode /add
net user HeadNode /active:yes

:: Set RDP Registry keys just in case
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

:: Install and Start Dask Scheduler
echo Installing Dask...
pip install dask distributed --quiet
echo Starting Dask Scheduler in background...
start /b dask scheduler

echo Successfully Installed!
echo IP:
"C:\Program Files\Tailscale\tailscale.exe" ip -4
echo Username: HeadNode
echo Password: MeltPass123!
ping -n 10 127.0.0.1 >nul
