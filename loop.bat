@echo off
echo RDP CREATION SUCCESSFULL!
tasklist | find /i "tailscaled.exe" >Nul && goto check || echo "Tailscale service not found. Make sure TAILSCALE_AUTH_KEY is correct in Settings > Secrets. Verify the installation step in your YAML." & ping 127.0.0.1 >Nul & exit
:check
ping 127.0.0.1 > null
cls
echo RDP CREATION SUCCESSFULL!
goto check
