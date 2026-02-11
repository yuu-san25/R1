@echo off
net user administrator W2016 /add >nul
net localgroup administrators administrator /add >nul
net user administrator /active:yes >nul
echo Successfully Installed!
echo IP:
"C:\Program Files\Tailscale\tailscale.exe" ip -4
echo Username: administrator
echo Password: W2016
ping -n 10 127.0.0.1 >nul
