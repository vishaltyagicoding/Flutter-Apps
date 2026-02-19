# LearnHub Startup Script with ngrok
Write-Host "Starting LearnHub with ngrok..." -ForegroundColor Green

# Start Django backend
Write-Host "Starting Django backend on port 8000..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'backend'; python manage.py runserver 8000"

# Wait for backend to initialize
Start-Sleep -Seconds 5

# Start ngrok for backend
Write-Host "Starting ngrok tunnel for backend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "ngrok http 8000"

# Start React frontend
Write-Host "Starting React frontend on port 3000..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'frontend'; npm start"

# Wait for frontend to initialize
Start-Sleep -Seconds 10

# Start ngrok for frontend
Write-Host "Starting ngrok tunnel for frontend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "ngrok http 3000"

Write-Host "`nAll services started!" -ForegroundColor Green
Write-Host "Local URLs:" -ForegroundColor Cyan
Write-Host "  Backend:  http://localhost:8000" -ForegroundColor White
Write-Host "  Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "`nCheck the ngrok windows for public URLs" -ForegroundColor Cyan

Read-Host "Press Enter to exit"