@echo off
cd /d "%~dp0backend"
copy /Y .env.docker.example .env > nul
npm.cmd install
npm.cmd start
