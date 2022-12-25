# PowerShell script to create and setup new Flutter project

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Eventos Admin - Fresh Project Setup" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Create new Flutter project
Write-Host "Step 1: Creating new Flutter project..." -ForegroundColor Yellow
cd "D:\Personal Projects\EventosApp"

# Check if Flutter is available
if (!(Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Flutter is not in your PATH!" -ForegroundColor Red
    Write-Host "Please add Flutter to your PATH and run this script again." -ForegroundColor Red
    Write-Host ""
    Write-Host "To add Flutter to PATH:" -ForegroundColor Yellow
    Write-Host "1. Find your Flutter installation (e.g., D:\Softwares\flutter\bin)" -ForegroundColor Yellow
    Write-Host "2. Add it to System Environment Variables" -ForegroundColor Yellow
    Write-Host "3. Restart PowerShell/IDE" -ForegroundColor Yellow
    pause
    exit 1
}

flutter create eventos_admin_new

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to create Flutter project!" -ForegroundColor Red
    pause
    exit 1
}

cd eventos_admin_new

# Step 2: Replace pubspec.yaml
Write-Host ""
Write-Host "Step 2: Updating pubspec.yaml with latest dependencies..." -ForegroundColor Yellow
Copy-Item "..\pubspec_new.yaml" "pubspec.yaml" -Force

# Step 3: Get dependencies
Write-Host ""
Write-Host "Step 3: Getting Flutter dependencies..." -ForegroundColor Yellow
flutter pub get

# Step 4: Copy source files
Write-Host ""
Write-Host "Step 4: Copying source files from old project..." -ForegroundColor Yellow
Copy-Item "..\eventos_admin\lib\*.dart" "lib\" -Force

# Step 5: Copy Firebase configuration
Write-Host ""
Write-Host "Step 5: Copying Firebase configuration..." -ForegroundColor Yellow
if (Test-Path "..\eventos_admin\android\app\google-services.json") {
    Copy-Item "..\eventos_admin\android\app\google-services.json" "android\app\" -Force
    Write-Host "  - Copied google-services.json" -ForegroundColor Green
} else {
    Write-Host "  - WARNING: google-services.json not found!" -ForegroundColor Red
}

# Step 6: Copy images folder if exists
Write-Host ""
Write-Host "Step 6: Checking for images folder..." -ForegroundColor Yellow
if (Test-Path "..\eventos_admin\images") {
    Copy-Item "..\eventos_admin\images" "." -Recurse -Force
    Write-Host "  - Copied images folder" -ForegroundColor Green
} else {
    Write-Host "  - No images folder found, skipping" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. cd eventos_admin_new" -ForegroundColor White
Write-Host "2. flutter doctor" -ForegroundColor White
Write-Host "3. flutter run" -ForegroundColor White
Write-Host ""
Write-Host "Project location: D:\Personal Projects\EventosApp\eventos_admin_new" -ForegroundColor Cyan
Write-Host ""
pause
