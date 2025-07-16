#!/bin/bash

# VS Code Extension Install Script
# This script installs the packaged extension to VS Code

set -e  # Exit on any error

echo "⬇️  VS Code Extension Install Script"
echo "===================================="

# Check if code command is available
if ! command -v code &> /dev/null; then
    echo "❌ VS Code 'code' command not found in PATH"
    echo "💡 Please make sure VS Code is installed and 'code' command is available"
    echo "   You can add it from VS Code: Ctrl+Shift+P -> 'Shell Command: Install code command in PATH'"
    exit 1
fi

# Get extension name and version from package.json
EXTENSION_NAME=$(node -p "require('./package.json').name")
EXTENSION_VERSION=$(node -p "require('./package.json').version")
VSIX_FILE="${EXTENSION_NAME}-${EXTENSION_VERSION}.vsix"

echo "📋 Extension: $EXTENSION_NAME"
echo "🏷️  Version: $EXTENSION_VERSION"
echo "📦 VSIX File: $VSIX_FILE"
echo ""

# Check if VSIX file exists
if [ ! -f "$VSIX_FILE" ]; then
    echo "❌ VSIX file not found: $VSIX_FILE"
    echo "💡 Please run package.sh first to create the package"
    exit 1
fi

# Uninstall previous version (ignore errors if not installed)
echo "🗑️  Uninstalling previous version (if exists)..."
code --uninstall-extension "$EXTENSION_NAME" || true

# Install the new extension
echo "⬇️  Installing extension to VS Code..."
code --install-extension "$VSIX_FILE"

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Extension successfully installed!"
    echo "📝 You can now test it in VS Code:"
    echo "   1. Open a C# file"
    echo "   2. Use Ctrl+Shift+P and search for 'Import missing references'"
    echo "   3. Or use the command: importAllUsings.run"
    echo "   4. Or use the keyboard shortcut: Alt+F Alt+U"
    echo ""
    echo "🔄 To reload VS Code and activate the extension:"
    echo "   Ctrl+Shift+P -> 'Developer: Reload Window'"
    echo ""
else
    echo "❌ Failed to install extension"
    exit 1
fi
