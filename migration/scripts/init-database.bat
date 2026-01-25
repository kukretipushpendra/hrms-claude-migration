@echo off
REM HRMS Database Initialization - Batch Wrapper
REM Run this file to execute the PowerShell script

echo.
echo ============================================
echo   HRMS Database Initialization
echo ============================================
echo.

REM Check if PowerShell is available
where powershell >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] PowerShell not found. Please install PowerShell.
    pause
    exit /b 1
)

REM Get the directory of this batch file
set SCRIPT_DIR=%~dp0

REM Run the PowerShell script
powershell -ExecutionPolicy Bypass -File "%SCRIPT_DIR%init-database.ps1" %*

if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] Database initialization failed.
    pause
    exit /b 1
)

echo.
echo Press any key to exit...
pause >nul
