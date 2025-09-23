@echo off
echo Step 1: Script started
pause

echo Step 2: Checking system variables
echo LOCALAPPDATA: %LOCALAPPDATA%
pause

echo Step 3: Checking if directories exist
if exist "%LOCALAPPDATA%" (
    echo LOCALAPPDATA exists
) else (
    echo LOCALAPPDATA does not exist
)
pause

echo Step 4: Testing basic commands
dir
pause

echo Step 5: Script completed
pause
