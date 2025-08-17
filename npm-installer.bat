@echo off
REM NPM Bulk Installer - Windows Batch Version
REM Author: Ersin KOC
REM Date: 2025-08-17
REM Description: Finds all package.json files and runs npm install

setlocal enabledelayedexpansion

REM Default values
if "%~1"=="" (
    set "START_PATH=%CD%"
) else (
    set "START_PATH=%~1"
)

if "%~2"=="" (
    set "LOG_FILE=npm-install-log.txt"
) else (
    set "LOG_FILE=%~2"
)

set "LOG_PATH=%START_PATH%\%LOG_FILE%"

REM Initialize log file
echo NPM Installation Log - %date% %time% > "%LOG_PATH%"

REM Welcome message
echo.
echo ========================================
echo     NPM Bulk Installer (Batch)
echo ========================================
echo Start directory: %START_PATH%
echo Log file: %LOG_PATH%

REM Check if npm is installed
npm --version >nul 2>&1
if errorlevel 1 (
    echo npm is not installed or not in PATH!
    exit /b 1
)

for /f "delims=" %%i in ('npm --version') do set NPM_VERSION=%%i
echo npm version: %NPM_VERSION%

REM Find and count package.json files
echo.
echo Searching for package.json files...

set COUNT=0
set SUCCESS_COUNT=0
set ERROR_COUNT=0

REM First pass: count files
for /r "%START_PATH%" %%f in (package.json) do (
    echo %%~dpf | find /i "node_modules" >nul
    if errorlevel 1 (
        set /a COUNT+=1
    )
)

if %COUNT%==0 (
    echo No package.json files found!
    exit /b 1
)

echo Found %COUNT% package.json files

REM Ask for confirmation
echo.
set /p CONFIRM=Proceed with npm install? (Y/N): 
if /i not "%CONFIRM%"=="Y" (
    echo Operation cancelled.
    exit /b 0
)

echo.
echo Starting npm install operations...
echo ========================================

REM Second pass: process files
set CURRENT=0
for /r "%START_PATH%" %%f in (package.json) do (
    echo %%~dpf | find /i "node_modules" >nul
    if errorlevel 1 (
        set /a CURRENT+=1
        
        REM Get relative path
        set "FULL_PATH=%%~dpf"
        set "REL_PATH=!FULL_PATH:%START_PATH%\=!"
        if "!REL_PATH!"=="!FULL_PATH!" set "REL_PATH=."
        
        echo.
        echo [!CURRENT!/%COUNT%] !REL_PATH!
        
        REM Log to file
        echo. >> "%LOG_PATH%"
        echo ---------------------------------------- >> "%LOG_PATH%"
        echo Directory: !REL_PATH! >> "%LOG_PATH%"
        echo Time: %time% >> "%LOG_PATH%"
        
        REM Change to directory
        pushd "%%~dpf"
        
        echo   Running npm install...
        
        REM Run npm install
        npm install >nul 2>&1
        if errorlevel 1 (
            set /a ERROR_COUNT+=1
            echo   [X] Failed!
            echo Status: FAILED >> "%LOG_PATH%"
        ) else (
            set /a SUCCESS_COUNT+=1
            echo   [OK] Success!
            echo Status: SUCCESS >> "%LOG_PATH%"
        )
        
        popd
    )
)

REM Summary
echo.
echo ========================================
echo          SUMMARY
echo ========================================
echo Total packages: %COUNT%
echo Successful: %SUCCESS_COUNT%
echo Failed: %ERROR_COUNT%

echo.
echo Log file saved to: %LOG_PATH%

REM Exit code
if %ERROR_COUNT% GTR 0 (
    exit /b 1
) else (
    echo.
    echo All packages installed successfully!
    exit /b 0
)