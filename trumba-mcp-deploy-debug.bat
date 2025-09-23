@echo off
REM Trumba Registration MCP - DEBUG VERSION
REM This version will stay open and show detailed error information

setlocal enabledelayedexpansion

echo.
echo =================================================================
echo Trumba Registration MCP - DEBUG VERSION
echo =================================================================
echo.
echo This debug version will show detailed information and stay open
echo if there are any errors.
echo.

REM Add error handling to prevent script from closing
set "ERROR_OCCURRED=0"

REM Function to handle errors
goto :main

:error_handler
echo.
echo =================================================================
echo ERROR DETECTED!
echo =================================================================
echo Error occurred at line: %1
echo Error level: %2
echo.
echo Press any key to continue or close this window to exit...
pause >nul
exit /b %2

:main
echo [DEBUG] Starting script execution...
echo [DEBUG] Current directory: %CD%
echo [DEBUG] User: %USERNAME%
echo [DEBUG] Computer: %COMPUTERNAME%
echo.

echo [DEBUG] Checking system variables...
echo [DEBUG] LOCALAPPDATA: %LOCALAPPDATA%
echo [DEBUG] PROGRAMFILES: %PROGRAMFILES%
echo [DEBUG] PROGRAMFILES(X86): %PROGRAMFILES(X86)%
echo [DEBUG] APPDATA: %APPDATA%
echo.

pause

REM Check for Claude Desktop - Enhanced detection with debug output
echo [%TIME%] Checking for Claude Desktop installation...
echo [DEBUG] Starting Claude Desktop detection...

set CLAUDE_FOUND=0

REM Check each location and show results
echo [DEBUG] Checking %LOCALAPPDATA%\Programs\Claude\Claude.exe...
if exist "%LOCALAPPDATA%\Programs\Claude\Claude.exe" (
    echo [DEBUG] ✅ Found: %LOCALAPPDATA%\Programs\Claude\Claude.exe
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Not found: %LOCALAPPDATA%\Programs\Claude\Claude.exe
)

echo [DEBUG] Checking %LOCALAPPDATA%\Programs\Claude\claude.exe...
if exist "%LOCALAPPDATA%\Programs\Claude\claude.exe" (
    echo [DEBUG] ✅ Found: %LOCALAPPDATA%\Programs\Claude\claude.exe
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Not found: %LOCALAPPDATA%\Programs\Claude\claude.exe
)

echo [DEBUG] Checking %PROGRAMFILES%\Claude\Claude.exe...
if exist "%PROGRAMFILES%\Claude\Claude.exe" (
    echo [DEBUG] ✅ Found: %PROGRAMFILES%\Claude\Claude.exe
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Not found: %PROGRAMFILES%\Claude\Claude.exe
)

echo [DEBUG] Checking %PROGRAMFILES%\Claude\claude.exe...
if exist "%PROGRAMFILES%\Claude\claude.exe" (
    echo [DEBUG] ✅ Found: %PROGRAMFILES%\Claude\claude.exe
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Not found: %PROGRAMFILES%\Claude\claude.exe
)

echo [DEBUG] Checking %PROGRAMFILES(X86)%\Claude\Claude.exe...
if exist "%PROGRAMFILES(X86)%\Claude\Claude.exe" (
    echo [DEBUG] ✅ Found: %PROGRAMFILES(X86)%\Claude\Claude.exe
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Not found: %PROGRAMFILES(X86)%\Claude\Claude.exe
)

echo [DEBUG] Checking %PROGRAMFILES(X86)%\Claude\claude.exe...
if exist "%PROGRAMFILES(X86)%\Claude\claude.exe" (
    echo [DEBUG] ✅ Found: %PROGRAMFILES(X86)%\Claude\claude.exe
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Not found: %PROGRAMFILES(X86)%\Claude\claude.exe
)

echo [DEBUG] Checking %LOCALAPPDATA%\Claude\Claude.exe...
if exist "%LOCALAPPDATA%\Claude\Claude.exe" (
    echo [DEBUG] ✅ Found: %LOCALAPPDATA%\Claude\Claude.exe
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Not found: %LOCALAPPDATA%\Claude\Claude.exe
)

echo [DEBUG] Checking %LOCALAPPDATA%\Claude\claude.exe...
if exist "%LOCALAPPDATA%\Claude\claude.exe" (
    echo [DEBUG] ✅ Found: %LOCALAPPDATA%\Claude\claude.exe
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Not found: %LOCALAPPDATA%\Claude\claude.exe
)

echo [DEBUG] Checking registry for Claude...
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "Claude" >nul 2>&1
if !errorlevel!==0 (
    echo [DEBUG] ✅ Found Claude in registry
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Claude not found in registry
)

echo [DEBUG] Checking Start Menu shortcuts...
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Claude.lnk" (
    echo [DEBUG] ✅ Found: Claude.lnk
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Not found: Claude.lnk
)

if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Claude Desktop.lnk" (
    echo [DEBUG] ✅ Found: Claude Desktop.lnk
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Not found: Claude Desktop.lnk
)

echo [DEBUG] Checking for running Claude processes...
tasklist /FI "IMAGENAME eq Claude.exe" 2>NUL | find /I /N "Claude.exe" >NUL
if !errorlevel!==0 (
    echo [DEBUG] ✅ Claude.exe is currently running
    set CLAUDE_FOUND=1
) else (
    echo [DEBUG] ❌ Claude.exe is not currently running
)

echo.
echo [DEBUG] Claude detection result: CLAUDE_FOUND=!CLAUDE_FOUND!

if !CLAUDE_FOUND!==0 (
    echo.
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

echo.
echo [DEBUG] Proceeding to Node.js check...
pause

REM Check for Node.js with debug output
echo [%TIME%] Checking for Node.js...
echo [DEBUG] Running: node --version
node --version
set NODE_ERROR=!errorlevel!
echo [DEBUG] Node.js check result: !NODE_ERROR!

if !NODE_ERROR!==0 (
    echo ✅ Node.js found
) else (
    echo ⚠️ Node.js not found - attempting to install...
    echo    This may take a few minutes...
    
    echo [DEBUG] Downloading Node.js installer...
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v18.17.0/node-v18.17.0-x64.msi' -OutFile '%TEMP%\nodejs-installer.msi'"
    
    if exist "%TEMP%\nodejs-installer.msi" (
        echo [DEBUG] ✅ Node.js installer downloaded successfully
        echo    Installing Node.js...
        msiexec /i "%TEMP%\nodejs-installer.msi" /quiet /norestart
        
        echo [DEBUG] Refreshing PATH...
        call refreshenv.cmd >nul 2>&1
        
        echo [DEBUG] Testing Node.js installation...
        node --version
        set NODE_TEST_ERROR=!errorlevel!
        if !NODE_TEST_ERROR!==0 (
            echo ✅ Node.js installed successfully
            del "%TEMP%\nodejs-installer.msi" >nul 2>&1
        ) else (
            echo ❌ Node.js installation failed
            echo    Please install Node.js manually from https://nodejs.org
            del "%TEMP%\nodejs-installer.msi" >nul 2>&1
            echo.
            echo [DEBUG] Press any key to continue anyway...
            pause
        )
    ) else (
        echo ❌ Failed to download Node.js installer
        echo    Please install Node.js manually from https://nodejs.org
        echo.
        echo [DEBUG] Press any key to continue anyway...
        pause
    )
)

echo.
echo [DEBUG] Creating bridge directory...
set BRIDGE_DIR=%APPDATA%\TrumbaMCP
echo [DEBUG] Bridge directory: %BRIDGE_DIR%
if not exist "%BRIDGE_DIR%" (
    echo [DEBUG] Creating directory: %BRIDGE_DIR%
    mkdir "%BRIDGE_DIR%"
    if !errorlevel!==0 (
        echo [DEBUG] ✅ Directory created successfully
    ) else (
        echo [DEBUG] ❌ Failed to create directory
        set ERROR_OCCURRED=1
    )
) else (
    echo [DEBUG] ✅ Directory already exists
)

echo.
echo [DEBUG] Script execution completed.
echo [DEBUG] Error status: !ERROR_OCCURRED!

if !ERROR_OCCURRED!==1 (
    echo.
    echo =================================================================
    echo ERRORS DETECTED DURING EXECUTION
    echo =================================================================
    echo Please check the debug output above for details.
    echo.
) else (
    echo.
    echo =================================================================
    echo SCRIPT EXECUTION COMPLETED SUCCESSFULLY
    echo =================================================================
    echo.
)

echo Press any key to exit...
pause >nul
