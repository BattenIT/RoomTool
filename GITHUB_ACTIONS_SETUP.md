# GitHub Actions Setup for Azure Static Web Apps

## 🎯 Overview
This guide will help you connect your GitHub repository to Azure Static Web Apps for automatic deployment.

## 🚀 Method 1: Automatic Setup (Easiest)

### Step 1: Create Azure Static Web App (if not exists)
1. Go to [Azure Portal](https://portal.azure.com)
2. Click "Create a resource" → "Static Web App"
3. **Important**: Choose "GitHub" as the source
4. Select your repository: `BattenIT/RoomTool`
5. Choose branch: `master`
6. Set build configuration:
   - **App location**: `/` (root)
   - **API location**: leave empty
   - **Output location**: leave empty

### Step 2: Azure Will Auto-Configure
When you create the Static Web App this way, Azure will:
- ✅ Automatically create the GitHub Actions workflow
- ✅ Add the deployment token as a secret
- ✅ Trigger the first deployment

## 🔧 Method 2: Manual Setup

If you already have an Azure Static Web App and want to connect it:

### Step 1: Get Deployment Token
1. Go to your Azure Static Web App in the portal
2. Click "Manage deployment token"
3. Copy the token

### Step 2: Add GitHub Secret
1. Go to https://github.com/BattenIT/RoomTool/settings/secrets/actions
2. Click "New repository secret"
3. Name: `AZURE_STATIC_WEB_APPS_API_TOKEN`
4. Value: [paste the token from Step 1]
5. Click "Add secret"

### Step 3: Push Workflow File
The workflow file is already created and will be pushed with your next commit.

## 📋 Current Setup Status

✅ **GitHub Actions workflow file created**: `.github/workflows/azure-static-web-apps.yml`
✅ **Repository connected**: https://github.com/BattenIT/RoomTool
✅ **Code ready for deployment**: Student Lounge 206 integration complete

## 🔑 Required Secrets

Your GitHub repository needs this secret for deployment:
- `AZURE_STATIC_WEB_APPS_API_TOKEN` - Deployment token from Azure Static Web App

## 🚨 Important: Azure Function Update

**Before deployment will work properly**, you must update your Azure Function to support `"studentlounge206"`:

```javascript
// Add this mapping to your Azure Function
"studentlounge206": "https://outlook.office365.com/owa/calendar/bfd63ea7933c4c3d965a632e5d6b703d@virginia.edu/05f41146b7274347a5e374b91f0e7eda6953039659626971784/calendar.ics"
```

## 📁 Deployment Configuration

The GitHub Actions workflow will deploy:
- **Source**: All files in repository root
- **Target**: Azure Static Web App
- **Trigger**: Push to master branch
- **Files deployed**: `index.html`, `config.js`, `styles.css`, etc.

## 🧪 Testing Deployment

After setup:
1. Push changes to the `master` branch
2. Check GitHub Actions: https://github.com/BattenIT/RoomTool/actions
3. Visit your Azure Static Web App URL
4. Verify Student Lounge 206 appears in Garrett Hall section

## 🆘 Troubleshooting

### GitHub Actions Not Running
- Check if `AZURE_STATIC_WEB_APPS_API_TOKEN` secret exists
- Verify token is valid (regenerate if needed)
- Ensure workflow file is in `.github/workflows/` directory

### Student Lounge 206 Not Loading
- Azure Function needs `"studentlounge206"` room ID mapping
- Check browser console for API errors
- Test Azure Function endpoint directly

### Deployment Fails
- Check GitHub Actions logs for error details
- Verify Azure Static Web App is running
- Confirm repository permissions

---

**Next Steps**: Choose Method 1 (Automatic) or Method 2 (Manual) above to complete the setup!