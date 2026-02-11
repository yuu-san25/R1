@echo off
:: Create user and set password
net user HeadNode MeltPass123! /add /y
net localgroup administrators HeadNode /add
net localgroup "Remote Desktop Users" HeadNode /add
net user HeadNode /active:yes

:: DISABLE NLA (This stops the "pre-connection" credential check)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f

:: Ensure RDP is generally allowed
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

echo Configuration Complete!
echo IP:
"C:\Program Files\Tailscale\tailscale.exe" ip -4
echo Username: HeadNode
echo Password: MeltPass123!
ping -n 10 127.0.0.1 >nul
