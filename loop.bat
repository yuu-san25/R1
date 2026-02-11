@echo off
echo RDP IS LIVE!
:check
tasklist | find /i "tailscaled.exe" >Nul && goto active || echo "Tailscale Error!" & exit
:active
ping 127.0.0.1 > nul
cls
echo RDP IS LIVE!
goto active
