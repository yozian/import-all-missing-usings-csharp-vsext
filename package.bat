@echo off
setlocal enabledelayedexpansion

REM VS Code Extension Package Script for Windows
REM This script packages the extension into a VSIX file

echo 📦 VS Code Extension Package Script
echo ====================================

REM Check if vsce is installed
where vsce >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ vsce (Visual Studio Code Extension Manager) is not installed
    echo 📦 Installing vsce globally...
    call npm install -g vsce
    if !ERRORLEVEL! NEQ 0 (
        echo ❌ Failed to install vsce
        exit /b 1
    )
)

REM Get extension name and version from package.json
for /f "delims=" %%i in ('node -p "require('./package.json').name"') do set EXTENSION_NAME=%%i
for /f "delims=" %%i in ('node -p "require('./package.json').version"') do set EXTENSION_VERSION=%%i
set VSIX_FILE=%EXTENSION_NAME%-%EXTENSION_VERSION%.vsix

echo 📋 Extension: %EXTENSION_NAME%
echo 🏷️  Version: %EXTENSION_VERSION%
echo 📦 VSIX File: %VSIX_FILE%
echo.

REM Clean up old VSIX files
echo 🧹 Cleaning up old VSIX files...
del /q *.vsix 2>nul

REM Install dependencies if node_modules doesn't exist
if not exist "node_modules" (
    echo 📦 Installing dependencies...
    call npm install
    if !ERRORLEVEL! NEQ 0 (
        echo ❌ Failed to install dependencies
        exit /b 1
    )
)

REM Package the extension
echo 📦 Packaging extension...
call vsce package
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to package extension
    exit /b 1
)

REM Check if packaging was successful
if not exist "%VSIX_FILE%" (
    echo ❌ Failed to create VSIX package
    exit /b 1
)

echo ✅ Package created successfully: %VSIX_FILE%
echo.
