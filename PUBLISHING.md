# Publishing Setup for VS Code Extension

This document explains how to set up automatic publishing to the VS Code Marketplace using GitHub Actions.

## Prerequisites

### 1. VS Code Marketplace Publisher Account
1. Go to [Visual Studio Marketplace](https://marketplace.visualstudio.com/)
2. Sign in with your Microsoft account
3. Click on "Publish extensions" 
4. Create a new publisher or use an existing one
5. Note down your publisher name

### 2. Personal Access Token (PAT)
1. Go to [Azure DevOps](https://dev.azure.com/)
2. Sign in with the same Microsoft account
3. Click on your profile → "Personal access tokens"
4. Create a new token with:
   - **Name**: VS Code Extension Publishing
   - **Organization**: All accessible organizations
   - **Expiration**: Custom defined (recommended: 1 year)
   - **Scopes**: Custom defined
   - **Marketplace**: Read & publish

### 3. GitHub Repository Secrets
1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Add the following repository secrets:
   - **VSCE_PAT**: Your Personal Access Token from step 2

## Setup Steps

### 1. Update package.json
Update the `publisher` field in your `package.json`:
```json
{
  "publisher": "your-actual-publisher-name"
}
```

### 2. Publishing Methods

#### Method 1: Tag-based Publishing (Recommended)
The GitHub Action will automatically trigger when you create a version tag:

```bash
# Update version in package.json first
npm version patch  # or minor/major
git push origin main
git push origin --tags
```

#### Method 2: Manual Publishing
1. Go to your GitHub repository
2. Navigate to Actions → "Publish Extension"
3. Click "Run workflow"
4. Select the branch and click "Run workflow"

## Version Management

The extension version is controlled by the `version` field in `package.json`. Use semantic versioning:
- **Patch** (1.0.1): Bug fixes
- **Minor** (1.1.0): New features (backward compatible)
- **Major** (2.0.0): Breaking changes

## Workflow Features

The GitHub Action workflow:
- ✅ Builds the extension package (.vsix)
- ✅ Publishes to VS Code Marketplace
- ✅ Creates a GitHub release with the package
- ✅ Uploads package as an artifact
- ✅ Validates package.json structure

## Troubleshooting

### Common Issues:
1. **Invalid publisher**: Update the `publisher` field in package.json
2. **Token expired**: Generate a new PAT and update the GitHub secret
3. **Permission denied**: Ensure the PAT has marketplace publish permissions

### Manual Publishing (if needed):
```bash
npm install -g @vscode/vsce
vsce login your-publisher-name
vsce publish
```
