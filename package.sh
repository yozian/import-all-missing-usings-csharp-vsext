#!/bin/bash

# VS Code Extension Package Script
# This script packages the extension into a VSIX file

set -e  # Exit on any error

echo "📦 VS Code Extension Package Script"
echo "===================================="

# Check if vsce is installed
if ! command -v vsce &> /dev/null; then
    echo "❌ vsce (Visual Studio Code Extension Manager) is not installed"
    echo "📦 Installing vsce globally..."
    npm install -g vsce
fi

# Get extension name and version from package.json
EXTENSION_NAME=$(node -p "require('./package.json').name")
EXTENSION_VERSION=$(node -p "require('./package.json').version")
VSIX_FILE="${EXTENSION_NAME}-${EXTENSION_VERSION}.vsix"

echo "📋 Extension: $EXTENSION_NAME"
echo "🏷️  Version: $EXTENSION_VERSION"
echo "📦 VSIX File: $VSIX_FILE"
echo ""

# Clean up old VSIX files
echo "🧹 Cleaning up old VSIX files..."
rm -f *.vsix

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Package the extension
echo "📦 Packaging extension..."
vsce package

# Check if packaging was successful
if [ ! -f "$VSIX_FILE" ]; then
    echo "❌ Failed to create VSIX package"
    exit 1
fi

echo "✅ Package created successfully: $VSIX_FILE"
echo ""
