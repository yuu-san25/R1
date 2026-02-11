@echo off
:: Cleanup and UI tweaks
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > out.txt 2>&1
net config server /srvcomment:"Windows Server 2019 via Tailscale" > out.txt 2>&1
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > out.txt 2>&1

:: Set Wallpaper (Updated path for GitHub Actions)
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v Wallpaper /t REG_SZ /d "C:\Users\Public\Desktop\wallpaper.bat"

:: Create Admin User
net user administrator W2016 /add >nul
net localgroup administrators administrator /add >nul
net user administrator /active:yes >nul

:: Clean up and Services
diskperf -Y >nul
sc config Audiosrv start= auto >nul
sc start audiosrv >nul
ICACLS C:\Windows\Temp /grant administrator:F >nul
ICACLS C:\Windows\installer /grant administrator:F >nul

echo ---------------------------------------
echo Successfully Installed!
echo ---------------------------------------

:: Get Tailscale IP
echo Fetching Tailscale IP...
for /f "tokens=*" %%a in ('tailscale ip -4') do set TS_IP=%%a

echo IP: %TS_IP%
echo Username: administrator
echo Password: W2016
echo ---------------------------------------
echo Please connect via your Tailscale network.
echo ---------------------------------------
ping -n 10 127.0.0.1 >nul
