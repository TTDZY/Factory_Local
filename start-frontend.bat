@echo off
cd /d "%~dp0frontend"
echo VITE_API_BASE_URL=http://localhost:5001/api> .env
npm.cmd install
npm.cmd run dev
