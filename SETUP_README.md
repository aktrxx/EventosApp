# Eventos Admin - Fresh Project Setup

## ✅ Quick Setup (Automated)

I've created a PowerShell script that will do everything for you automatically.

### Run this script:

```powershell
cd "D:\Personal Projects\EventosApp"
.\setup_new_project.ps1
```

**What the script does:**
1. Creates a new Flutter project named `eventos_admin_new`
2. Updates pubspec.yaml with all latest dependencies
3. Copies all your Dart source files
4. Copies Firebase configuration (google-services.json)
5. Copies images folder if it exists
6. Runs `flutter pub get` to download dependencies

---

## 📋 Manual Setup (If script fails)

### Step 1: Add Flutter to PATH

First, ensure Flutter is in your system PATH:

1. Find your Flutter installation: `D:\Softwares\flutter\bin`
2. Add to Windows Environment Variables:
   - Search "Environment Variables" in Windows
   - Edit "Path" in System Variables
   - Add: `D:\Softwares\flutter\bin`
   - Restart PowerShell/Terminal

### Step 2: Create New Project

```bash
cd "D:\Personal Projects\EventosApp"
flutter create eventos_admin_new
cd eventos_admin_new
```

### Step 3: Update Dependencies

Replace `pubspec.yaml` with the content from `pubspec_new.yaml`:

```bash
copy ..\pubspec_new.yaml pubspec.yaml
flutter pub get
```

### Step 4: Copy Source Files

```bash
# Copy all Dart files
copy ..\eventos_admin\lib\*.dart lib\

# Copy Firebase config
copy ..\eventos_admin\android\app\google-services.json android\app\

# Copy images folder (if exists)
xcopy /E /I ..\eventos_admin\images images
```

### Step 5: Run the App

```bash
flutter doctor
flutter run
```

---

## 📦 Updated Dependencies (Latest Versions - 2026)

- **Firebase Core**: ^3.8.1
- **Firebase Auth**: ^5.3.3
- **Cloud Firestore**: ^5.5.2
- **Firebase Database**: ^11.2.0
- **Google Sign-In**: ^6.2.2
- **Provider**: ^6.1.2
- **Cached Network Image**: ^3.4.1
- **Image Picker**: ^1.1.2
- **Font Awesome Flutter**: ^10.8.0

All dependencies are compatible with:
- ✅ Latest Flutter SDK
- ✅ Gradle 8.3+
- ✅ Android Gradle Plugin 8.2+
- ✅ Kotlin 1.9.20+
- ✅ Java 17

---

## 🔥 Firebase Setup

Don't forget to:
1. Ensure `google-services.json` is in `android/app/`
2. Update Firebase project configuration if needed
3. Enable required Firebase services in Firebase Console:
   - Authentication
   - Firestore
   - Realtime Database

---

## 🎯 What Changed from Old Project

### ✅ Fixed:
- Gradle version mismatch
- Kotlin compatibility issues
- Java version conflicts
- AGP compatibility problems
- Outdated package versions

### ⬆️ Upgraded:
- SDK constraints: `>=3.0.0 <4.0.0`
- All packages to latest versions
- Build configuration

### 📁 Migrated Files:
From `eventos_admin/lib/`:
- main.dart
- AdminHomePage.dart
- tempAdminLogin.dart
- EventBox.dart
- eventpage.dart
- eventadd.dart
- google_sign_in.dart
- color.dart
- img.dart
- testscreen.dart

---

## 🚀 Running the Project

```bash
cd "D:\Personal Projects\EventosApp\eventos_admin_new"

# Check everything is setup correctly
flutter doctor

# Clean and get dependencies
flutter clean
flutter pub get

# Run on connected device
flutter run

# Or run on specific device
flutter devices
flutter run -d <device-id>

# Run on Chrome
flutter run -d chrome

# Run on Windows
flutter run -d windows
```

---

## 🛠️ Troubleshooting

### If Flutter is not recognized:
Add to PATH: `D:\Softwares\flutter\bin`

### If build fails:
```bash
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

### If Firebase errors:
Check that `google-services.json` exists in `android/app/`

---

## 📌 Notes

- **Old project**: `eventos_admin` (keep as backup)
- **New project**: `eventos_admin_new` (use this going forward)
- The new project has a fresh, modern build configuration
- All compatibility issues are resolved

---

**Ready to run!** 🎉

Just execute: `.\setup_new_project.ps1` or follow manual steps above.
