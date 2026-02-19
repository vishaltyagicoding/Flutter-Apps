@echo off
echo Starting ngrok tunnels...

start "Backend Ngrok" cmd /c "ngrok http 8000"
timeout /t 3 /nobreak >nul
start "Frontend Ngrok" cmd /c "ngrok http 3000"

echo Ngrok tunnels started!
echo Check the ngrok windows for public URLs
pause