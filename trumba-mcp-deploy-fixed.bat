@echo off
REM Trumba Registration MCP - Windows Batch Deployment Script (FIXED)
REM This script configures Claude Desktop to connect to the Azure-hosted Trumba MCP server

setlocal enabledelayedexpansion

echo.
echo =================================================================
echo Trumba Registration MCP - Windows Deployment Script v1.0.0 (FIXED)
echo =================================================================
echo.
echo This script will configure Claude Desktop to access Trumba event
echo registration tools via the Azure-hosted MCP server.
echo.
echo REQUIREMENTS:
echo - Claude Desktop installed
echo - Node.js installed (will attempt to install if missing)
echo - Internet connection
echo.

pause

REM Check for Claude Desktop - Enhanced detection
echo [%TIME%] Checking for Claude Desktop installation...
set CLAUDE_FOUND=0

REM Check common Claude Desktop installation paths
if exist "%LOCALAPPDATA%\Programs\Claude\Claude.exe" set CLAUDE_FOUND=1
if exist "%LOCALAPPDATA%\Programs\Claude\claude.exe" set CLAUDE_FOUND=1
if exist "%PROGRAMFILES%\Claude\Claude.exe" set CLAUDE_FOUND=1
if exist "%PROGRAMFILES%\Claude\claude.exe" set CLAUDE_FOUND=1
if exist "%PROGRAMFILES(X86)%\Claude\Claude.exe" set CLAUDE_FOUND=1
if exist "%PROGRAMFILES(X86)%\Claude\claude.exe" set CLAUDE_FOUND=1

REM Check for Claude Desktop in AppData (alternative installation)
if exist "%LOCALAPPDATA%\Claude\Claude.exe" set CLAUDE_FOUND=1
if exist "%LOCALAPPDATA%\Claude\claude.exe" set CLAUDE_FOUND=1

REM Check for Claude Desktop via registry (if installed via installer)
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "Claude" >nul 2>&1
if !errorlevel!==0 set CLAUDE_FOUND=1

REM Check for Claude Desktop via Start Menu shortcuts
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Claude.lnk" set CLAUDE_FOUND=1
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Claude Desktop.lnk" set CLAUDE_FOUND=1

REM Check for Claude Desktop process (if currently running)
tasklist /FI "IMAGENAME eq Claude.exe" 2>NUL | find /I /N "Claude.exe" >NUL
if !errorlevel!==0 set CLAUDE_FOUND=1

if !CLAUDE_FOUND!==0 (
    echo ❌ Claude Desktop not found
    echo.
    echo Claude Desktop may be installed in a non-standard location.
    echo Please ensure Claude Desktop is installed from: https://claude.ai/desktop
    echo.
    echo Common installation locations checked:
    echo - %LOCALAPPDATA%\Programs\Claude\
    echo - %PROGRAMFILES%\Claude\
    echo - %PROGRAMFILES(X86)%\Claude\
    echo - %LOCALAPPDATA%\Claude\
    echo.
    echo If Claude Desktop is installed elsewhere, you can:
    echo 1. Skip this check by pressing any key to continue
    echo 2. Or install Claude Desktop from the official website
    echo.
    pause
    echo.
    echo ⚠️ Continuing without Claude Desktop verification...
    echo    You may need to manually configure the MCP server later.
    echo.
) else (
    echo ✅ Claude Desktop found
)

REM Check for Node.js
echo [%TIME%] Checking for Node.js...
node --version >nul 2>&1
if !errorlevel!==0 (
    echo ✅ Node.js found
) else (
    echo ⚠️ Node.js not found - attempting to install...
    echo    This may take a few minutes...
    
    REM Download Node.js installer
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v18.17.0/node-v18.17.0-x64.msi' -OutFile '%TEMP%\nodejs-installer.msi'"
    
    if exist "%TEMP%\nodejs-installer.msi" (
        echo    Installing Node.js...
        msiexec /i "%TEMP%\nodejs-installer.msi" /quiet /norestart
        
        REM Refresh PATH
        call refreshenv.cmd >nul 2>&1
        
        REM Test again
        node --version >nul 2>&1
        if !errorlevel!==0 (
            echo ✅ Node.js installed successfully
            del "%TEMP%\nodejs-installer.msi" >nul 2>&1
        ) else (
            echo ❌ Node.js installation failed
            echo    Please install Node.js manually from https://nodejs.org
            del "%TEMP%\nodejs-installer.msi" >nul 2>&1
            pause
            exit /b 1
        )
    ) else (
        echo ❌ Failed to download Node.js installer
        echo    Please install Node.js manually from https://nodejs.org
        pause
        exit /b 1
    )
)

REM Create bridge directory
set BRIDGE_DIR=%APPDATA%\TrumbaMCP
echo [%TIME%] Creating bridge directory: %BRIDGE_DIR%
if not exist "%BRIDGE_DIR%" mkdir "%BRIDGE_DIR%"

REM Create HTTP bridge script
echo [%TIME%] Creating HTTP bridge script...
(
echo #!/usr/bin/env node
echo.
echo const { Server } = require('@modelcontextprotocol/sdk/server/index.js'^);
echo const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js'^);
echo const {
echo   CallToolRequestSchema,
echo   ListToolsRequestSchema,
echo } = require('@modelcontextprotocol/sdk/types.js'^);
echo.
echo class TrumbaHttpBridge {
echo   constructor(^) {
echo     this.serverUrl = process.env.AZURE_SERVER_URL ^|^| 'http://4.157.220.208:3000/api';
echo     this.apiKey = process.env.MCP_API_KEY ^|^| '6f85072b7a861d2d315bc4aba126f2ffee963851611c04e3b52fec4775996d69';
echo     
echo     this.server = new Server(
echo       {
echo         name: 'trumba-registration-mcp-bridge',
echo         version: '1.0.0',
echo       },
echo       {
echo         capabilities: {
echo           tools: { listChanged: true },
echo         },
echo       }
echo     ^);
echo.
echo     this.setupHandlers(^);
echo     console.error('🚀 Starting Trumba Registration MCP HTTP Bridge...'^);
echo     console.error(`🔗 Connecting to: ${this.serverUrl}`^);
echo     console.error(`🔑 API Key: ${this.apiKey.substring(0, 8^)}...`^);
echo   }
echo.
echo   setupHandlers(^) {
echo     this.server.setRequestHandler(ListToolsRequestSchema, async (^) =^> {
echo       console.error('🔧 Bridge: Fetching tools from Azure Trumba server...'^);
echo       
echo       try {
echo         console.error(`🌐 Bridge: Making request to ${this.serverUrl}/tools`^);
echo         const response = await fetch(`${this.serverUrl}/tools`, {
echo           headers: {
echo             'Authorization': `Bearer ${this.apiKey}`,
echo             'Content-Type': 'application/json'
echo           }
echo         }^);
echo.
echo         if (^!response.ok^) {
echo           throw new Error(`HTTP ${response.status}: ${response.statusText}`^);
echo         }
echo.
echo         const tools = await response.json(^);
echo         console.error(`✅ Bridge: Successfully fetched ${tools.length} tools`^);
echo         
echo         return { tools };
echo       } catch (error^) {
echo         console.error(`❌ Bridge: Failed to fetch tools: ${error.message}`^);
echo         return { tools: [] };
echo       }
echo     }^);
echo.
echo     this.server.setRequestHandler(CallToolRequestSchema, async (request^) =^> {
echo       const { name, arguments: args } = request.params;
echo       console.error(`🔧 Bridge: Executing tool "${name}"`^);
echo.
echo       try {
echo         const response = await fetch(`${this.serverUrl}/call`, {
echo           method: 'POST',
echo           headers: {
echo             'Authorization': `Bearer ${this.apiKey}`,
echo             'Content-Type': 'application/json'
echo           },
echo           body: JSON.stringify(^{
echo             method: name,
echo             params: args
echo           }^)
echo         }^);
echo.
echo         if (^!response.ok^) {
echo           throw new Error(`HTTP ${response.status}: ${response.statusText}`^);
echo         }
echo.
echo         const result = await response.json(^);
echo         console.error(`✅ Bridge: Tool "${name}" executed successfully`^);
echo         
echo         return result;
echo       } catch (error^) {
echo         console.error(`❌ Bridge: Tool execution failed: ${error.message}`^);
echo         return {
echo           content: [{
echo             type: 'text',
echo             text: JSON.stringify(^{
echo               success: false,
echo               error: error.message,
echo               timestamp: new Date(^).toISOString(^)
echo             }, null, 2^)
echo           }]
echo         };
echo       }
echo     }^);
echo   }
echo.
echo   async start(^) {
echo     const transport = new StdioServerTransport(^);
echo     await this.server.connect(transport^);
echo     console.error('✅ Trumba Registration MCP HTTP Bridge started successfully'^);
echo   }
echo }
echo.
echo const bridge = new TrumbaHttpBridge(^);
echo bridge.start(^).catch((error^) =^> {
echo   console.error('❌ Failed to start bridge:', error^);
echo   process.exit(1^);
echo }^);
) > "%BRIDGE_DIR%\http-bridge.js"

if exist "%BRIDGE_DIR%\http-bridge.js" (
    echo ✅ HTTP bridge script created
) else (
    echo ❌ Failed to create HTTP bridge script
    pause
    exit /b 1
)

REM Create package.json
echo [%TIME%] Creating package.json...
(
echo {
echo   "name": "trumba-mcp-bridge",
echo   "version": "1.0.0",
echo   "description": "HTTP bridge for Trumba MCP",
echo   "dependencies": {
echo     "@modelcontextprotocol/sdk": "^1.0.0"
echo   }
echo }
) > "%BRIDGE_DIR%\package.json"

REM Install Node modules
echo [%TIME%] Installing Node.js modules...
cd /d "%BRIDGE_DIR%"
call npm install --silent
if !errorlevel!==0 (
    echo ✅ Node.js modules installed
) else (
    echo ⚠️ Warning: Failed to install Node.js modules
)

REM Configure Claude Desktop
set CONFIG_PATH=%APPDATA%\Claude\claude_desktop_config.json
echo [%TIME%] Configuring Claude Desktop...

REM Backup existing config
if exist "%CONFIG_PATH%" (
    set BACKUP_PATH=%CONFIG_PATH%.backup.%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%-%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
    copy "%CONFIG_PATH%" "!BACKUP_PATH!" >nul 2>&1
    echo ✅ Configuration backed up to: !BACKUP_PATH!
)

REM Create config directory if it doesn't exist
if not exist "%APPDATA%\Claude" mkdir "%APPDATA%\Claude"

REM Create or update configuration
(
echo {
echo   "mcpServers": {
echo     "trumba-registration": {
echo       "command": "node",
echo       "args": [
echo         "%BRIDGE_DIR:\=\\%\\http-bridge.js"
echo       ],
echo       "env": {
echo         "AZURE_SERVER_URL": "http://4.157.220.208:3000/api",
echo         "MCP_API_KEY": "6f85072b7a861d2d315bc4aba126f2ffee963851611c04e3b52fec4775996d69"
echo       }
echo     }
echo   }
echo }
) > "%CONFIG_PATH%"

if exist "%CONFIG_PATH%" (
    echo ✅ Claude Desktop configuration updated
) else (
    echo ❌ Failed to update Claude Desktop configuration
    pause
    exit /b 1
)

REM Test Azure connection
echo [%TIME%] Testing Azure connection...
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://4.157.220.208:3000/api/tools' -Headers @{'Authorization'='Bearer 6f85072b7a861d2d315bc4aba126f2ffee963851611c04e3b52fec4775996d69'} -UseBasicParsing -TimeoutSec 10; if($response.StatusCode -eq 200) { Write-Host '✅ Azure connection successful' } } catch { Write-Host '⚠️ Azure connection test failed' }"

echo.
echo =================================================================
echo ✅ Trumba MCP deployment completed successfully!
echo =================================================================
echo.
echo 🎯 NEXT STEPS:
echo 1. Completely close Claude Desktop (Alt+F4 or File → Exit)
echo 2. Wait 5 seconds  
echo 3. Restart Claude Desktop
echo 4. Open a new conversation
echo 5. Ask: "What tools do you have access to?"
echo 6. You should see 5 Trumba registration tools!
echo.
echo 🧪 TEST QUERIES:
echo • "Show me recent event registrations"
echo • "Get registrations for today"
echo • "Find registrations for john.doe@example.com"
echo • "Export last week's registrations as CSV"
echo.
echo 📧 AVAILABLE TOOLS:
echo • trumba_get_registrations - Get event registrations with filtering
echo • trumba_get_event_summary - Generate event summaries  
echo • trumba_search_attendee - Find attendees by name/email
echo • trumba_get_recent_registrations - Monitor recent activity
echo • trumba_export_registrations - Export data in multiple formats
echo.
echo 🆘 TROUBLESHOOTING:
echo • If tools don't appear: Check that Node.js is in your PATH
echo • If connection fails: Verify internet connection to Azure
echo • For support: Contact your system administrator
echo.

pause
