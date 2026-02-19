const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

// Start ngrok for backend
const backendNgrok = spawn('ngrok', ['http', '8000', '--log=stdout'], {
  stdio: ['pipe', 'pipe', 'pipe']
});

// Start ngrok for frontend  
const frontendNgrok = spawn('ngrok', ['http', '3000', '--log=stdout'], {
  stdio: ['pipe', 'pipe', 'pipe']
});

let backendUrl = '';
let frontendUrl = '';

// Parse backend ngrok output
backendNgrok.stdout.on('data', (data) => {
  const output = data.toString();
  const match = output.match(/https:\/\/[a-z0-9-]+\.ngrok\.io/);
  if (match && !backendUrl) {
    backendUrl = match[0];
    console.log(`Backend URL: ${backendUrl}`);
    updateFrontendConfig();
  }
});

// Parse frontend ngrok output
frontendNgrok.stdout.on('data', (data) => {
  const output = data.toString();
  const match = output.match(/https:\/\/[a-z0-9-]+\.ngrok\.io/);
  if (match && !frontendUrl) {
    frontendUrl = match[0];
    console.log(`Frontend URL: ${frontendUrl}`);
    console.log(`\nShare this URL: ${frontendUrl}`);
  }
});

function updateFrontendConfig() {
  if (!backendUrl) return;
  
  const envPath = path.join(__dirname, 'frontend', '.env');
  const envContent = `REACT_APP_API_URL=${backendUrl}\n`;
  
  fs.writeFileSync(envPath, envContent);
  console.log('Frontend config updated with backend URL');
}