#!/bin/bash

# VS Code Extension Package and Install Script
# This script packages the extension and installs it to VS Code for testing

set -e  # Exit on any error

echo "🔧 VS Code Extension Package and Install Script"
echo "================================================"

# Step 1: Package the extension
echo "📦 Step 1: Packaging extension..."
./package.sh

echo ""
echo "⬇️  Step 2: Installing extension..."
./install.sh

echo "✨ Done!"
