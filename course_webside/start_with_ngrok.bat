@echo off
echo Starting LearnHub with ngrok...

REM Start Django backend
echo Starting Django backend...
start "Django Backend" cmd /k "cd /d backend && python manage.py runserver 8000"

REM Wait for backend to start
timeout /t 5 /nobreak >nul

REM Start ngrok for backend
echo Starting ngrok for backend (port 8000)...
start "Ngrok Backend" cmd /k "ngrok http 8000"

REM Start React frontend
echo Starting React frontend...
start "React Frontend" cmd /k "cd /d frontend && npm start"

REM Wait for frontend to start
timeout /t 10 /nobreak >nul

REM Start ngrok for frontend
echo Starting ngrok for frontend (port 3000)...
start "Ngrok Frontend" cmd /k "ngrok http 3000"

echo All services started!
echo Backend: http://localhost:8000
echo Frontend: http://localhost:3000
echo Check ngrok windows for public URLs
pause