@echo off
setlocal enabledelayedexpansion

REM VS Code Extension Install Script for Windows
REM This script installs the packaged extension to VS Code

echo ⬇️  VS Code Extension Install Script
echo ====================================

REM Check if code command is available
where code >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ VS Code 'code' command not found in PATH
    echo 💡 Please make sure VS Code is installed and 'code' command is available
    echo    You can add it from VS Code: Ctrl+Shift+P -^> 'Shell Command: Install code command in PATH'
    exit /b 1
)

REM Get extension name and version from package.json
for /f "delims=" %%i in ('node -p "require('./package.json').name"') do set EXTENSION_NAME=%%i
for /f "delims=" %%i in ('node -p "require('./package.json').version"') do set EXTENSION_VERSION=%%i
set VSIX_FILE=%EXTENSION_NAME%-%EXTENSION_VERSION%.vsix

echo 📋 Extension: %EXTENSION_NAME%
echo 🏷️  Version: %EXTENSION_VERSION%
echo 📦 VSIX File: %VSIX_FILE%
echo.

REM Check if VSIX file exists
if not exist "%VSIX_FILE%" (
    echo ❌ VSIX file not found: %VSIX_FILE%
    echo 💡 Please run package.bat first to create the package
    exit /b 1
)

REM Uninstall previous version (ignore errors if not installed)
echo 🗑️  Uninstalling previous version (if exists)...
code --uninstall-extension "%EXTENSION_NAME%" 2>nul

REM Install the new extension
echo ⬇️  Installing extension to VS Code...
code --install-extension "%VSIX_FILE%"
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to install extension
    exit /b 1
)

echo.
echo 🎉 Extension successfully installed!
echo 📝 You can now test it in VS Code:
echo    1. Open a C# file
echo    2. Use Ctrl+Shift+P and search for 'Import missing references'
echo    3. Or use the command: importAllUsings.run
echo    4. Or use the keyboard shortcut: Alt+F Alt+U
echo.
echo 🔄 To reload VS Code and activate the extension:
echo    Ctrl+Shift+P -^> 'Developer: Reload Window'
echo.
