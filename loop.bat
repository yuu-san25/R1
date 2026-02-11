@echo off
echo RDP CREATION SUCCESSFUL!

:check
:: Check if the Tailscale service is still running
sc query "Tailscale" | find "RUNNING" >nul
if %errorlevel% neq 0 (
    echo "Tailscale service is not running. Connection might be lost."
    ping 127.0.0.1 -n 10 >nul
    exit
)

:: Clear screen and keep the session alive
cls
echo RDP IS ACTIVE!
echo Keep this window open to prevent the RDP from closing.
ping 127.0.0.1 -n 30 >nul
goto check
