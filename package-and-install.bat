@echo off
setlocal enabledelayedexpansion

REM VS Code Extension Package and Install Script for Windows
REM This script packages the extension and installs it to VS Code for testing

echo 🔧 VS Code Extension Package and Install Script
echo ================================================

REM Step 1: Package the extension
echo 📦 Step 1: Packaging extension...
call package.bat
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to package extension
    pause
    exit /b 1
)

echo.
echo ⬇️  Step 2: Installing extension...
call install.bat
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to install extension
    pause
    exit /b 1
)

echo.
echo ✨ Done!
pause
