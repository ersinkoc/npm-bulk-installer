@echo off
REM NPM Bulk Installer - Windows Batch Version
REM Author: Ersin KOC
REM Date: 2025-08-17

setlocal enabledelayedexpansion

echo.
echo ========================================
echo     NPM Bulk Installer (Batch)
echo ========================================
echo.

REM Check if npm exists
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: npm is not installed or not in PATH!
    echo Please install Node.js first.
    pause
    exit /b 1
)

REM Get npm version
for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
echo npm version: %NPM_VERSION%
echo.

REM Set working directory
if "%~1"=="" (
    set "WORK_DIR=%CD%"
) else (
    set "WORK_DIR=%~1"
)

echo Working directory: %WORK_DIR%
echo.
echo Searching for package.json files...
echo ========================================

REM Create temp file for storing paths
set "TEMP_FILE=%TEMP%\npm_dirs_%RANDOM%.txt"
type nul > "%TEMP_FILE%"

REM Find all package.json files and store their directories
set count=0
for /r "%WORK_DIR%" %%f in (package.json) do (
    set "filepath=%%f"
    set "dirpath=%%~dpf"
    
    REM Check if this is actually a package.json file (not a directory)
    if exist "%%f" (
        REM Check if path contains node_modules
        echo !filepath! | findstr /i "node_modules" >nul 2>&1
        if errorlevel 1 (
            set /a count+=1
            echo !dirpath! >> "%TEMP_FILE%"
            
            REM Display found package.json
            set "relpath=!dirpath:%WORK_DIR%\=!"
            if "!relpath!"=="!dirpath!" set "relpath=."
            echo   [!count!] Found: !relpath!package.json
        )
    )
)

echo ========================================

if %count%==0 (
    echo No package.json files found ^(excluding node_modules^)
    del "%TEMP_FILE%" >nul 2>&1
    pause
    exit /b 1
)

echo.
echo Total: %count% package.json file^(s^) found
echo.

REM Ask for confirmation
set /p answer=Do you want to run npm install in these directories? (Y/N): 
if /i not "%answer%"=="Y" (
    echo Operation cancelled.
    del "%TEMP_FILE%" >nul 2>&1
    pause
    exit /b 0
)

echo.
echo Starting npm install operations...
echo ========================================

REM Process each directory from temp file
set current=0
set success=0
set failed=0

for /f "usebackq delims=" %%d in ("%TEMP_FILE%") do (
    set /a current+=1
    set "dirpath=%%d"
    
    REM Get relative path for display
    set "relpath=!dirpath:%WORK_DIR%\=!"
    if "!relpath!"=="!dirpath!" set "relpath=."
    
    echo.
    echo [!current!/%count%] Processing: !relpath!
    
    REM Change to directory
    cd /d "!dirpath!" 2>nul
    if !errorlevel! neq 0 (
        echo   [ERROR] Cannot access directory
        set /a failed+=1
    ) else (
        echo   Running npm install...
        
        REM Run npm install
        call npm install
        
        if !errorlevel! equ 0 (
            echo   [SUCCESS] npm install completed
            set /a success+=1
        ) else (
            echo   [FAILED] npm install failed with error code: !errorlevel!
            set /a failed+=1
        )
    )
)

REM Clean up temp file
del "%TEMP_FILE%" >nul 2>&1

REM Return to original directory
cd /d "%WORK_DIR%"

REM Show summary
echo.
echo ========================================
echo              SUMMARY
echo ========================================
echo Total directories: %count%
echo Successful: %success%
echo Failed: %failed%
echo ========================================
echo.

if %failed% gtr 0 (
    echo Warning: Some installations failed!
) else (
    echo All installations completed successfully!
)

echo.
pause