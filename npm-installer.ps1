# Simple NPM Package Installer Script
# This script finds all package.json files and runs npm install

param(
    [string]$StartPath = (Get-Location).Path,
    [string]$LogFile = "npm-install-log.txt",
    [switch]$SkipConfirmation = $false
)

# Initialize
$LogPath = Join-Path $StartPath $LogFile
"NPM Installation Log - $(Get-Date)" | Out-File -FilePath $LogPath -Encoding UTF8

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "    NPM Package Installer (Simple)" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Start directory: $StartPath" -ForegroundColor White
Write-Host "Log file: $LogPath" -ForegroundColor White

# Find package.json files
Write-Host "`nSearching for package.json files..." -ForegroundColor Yellow
$packageJsonFiles = Get-ChildItem -Path $StartPath -Filter "package.json" -Recurse -ErrorAction SilentlyContinue | 
    Where-Object { $_.DirectoryName -notmatch "node_modules" }

if ($packageJsonFiles.Count -eq 0) {
    Write-Host "No package.json files found!" -ForegroundColor Red
    exit 1
}

Write-Host "Found $($packageJsonFiles.Count) package.json files" -ForegroundColor Green

# List directories
Write-Host "`nDirectories to process:" -ForegroundColor Cyan
$index = 1
foreach ($file in $packageJsonFiles) {
    $relativePath = $file.DirectoryName.Replace($StartPath, "").TrimStart("\")
    if ($relativePath -eq "") { $relativePath = "." }
    Write-Host "  [$index] $relativePath" -ForegroundColor Gray
    $index++
}

# Confirmation
if (-not $SkipConfirmation) {
    $response = Read-Host "`nProceed with npm install? (Y/N)"
    if ($response -ne "Y" -and $response -ne "y") {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Process each directory
$successCount = 0
$errorCount = 0
$results = @()

Write-Host "`nStarting npm install operations..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

foreach ($file in $packageJsonFiles) {
    $directory = $file.DirectoryName
    $relativePath = $directory.Replace($StartPath, "").TrimStart("\")
    if ($relativePath -eq "") { $relativePath = "." }
    
    Write-Host "`n[$($packageJsonFiles.IndexOf($file) + 1)/$($packageJsonFiles.Count)] $relativePath" -ForegroundColor Yellow
    
    # Log to file
    "`n----------------------------------------" | Add-Content -Path $LogPath
    "Directory: $relativePath" | Add-Content -Path $LogPath
    "Time: $(Get-Date -Format 'HH:mm:ss')" | Add-Content -Path $LogPath
    
    # Change to directory and run npm install
    Push-Location $directory
    
    try {
        Write-Host "  Running npm install..." -ForegroundColor Gray
        
        # Run npm install using cmd for reliability
        $output = cmd /c "npm install 2>&1"
        $exitCode = $LASTEXITCODE
        
        # Log output
        $output | Add-Content -Path $LogPath
        
        if ($exitCode -eq 0) {
            $successCount++
            Write-Host "  [OK] Success!" -ForegroundColor Green
            $results += @{Path=$relativePath; Status="SUCCESS"}
            "Status: SUCCESS" | Add-Content -Path $LogPath
        } else {
            $errorCount++
            Write-Host "  [X] Failed! (Exit code: $exitCode)" -ForegroundColor Red
            $results += @{Path=$relativePath; Status="FAILED"}
            "Status: FAILED (Exit code: $exitCode)" | Add-Content -Path $LogPath
        }
    }
    catch {
        $errorCount++
        Write-Host "  [X] Error: $_" -ForegroundColor Red
        $results += @{Path=$relativePath; Status="ERROR"}
        "Status: ERROR - $_" | Add-Content -Path $LogPath
    }
    finally {
        Pop-Location
    }
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "         SUMMARY" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total packages: $($packageJsonFiles.Count)" -ForegroundColor White
Write-Host "Successful: $successCount" -ForegroundColor Green
Write-Host "Failed: $errorCount" -ForegroundColor Red

# Show failed directories
if ($errorCount -gt 0) {
    Write-Host "`nFailed directories:" -ForegroundColor Red
    foreach ($result in $results | Where-Object { $_.Status -ne "SUCCESS" }) {
        Write-Host "  - $($result.Path)" -ForegroundColor Red
    }
}

Write-Host "`nLog file saved to: $LogPath" -ForegroundColor Yellow

# Exit code
if ($errorCount -gt 0) {
    exit 1
} else {
    Write-Host "`nAll packages installed successfully!" -ForegroundColor Green
    exit 0
}