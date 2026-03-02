# Environment Setup Guide

This guide walks you through installing everything you need to run Flutter apps on your laptop.

**What you will install:**
- Flutter SDK (the framework)
- VS Code (the code editor)
- Dart & Flutter extensions for VS Code
- Android Studio + an Android emulator (or a physical Android device)

---

## Windows

### Step 1 — Download Flutter SDK

1. Go to [flutter.dev/docs/get-started/install/windows](https://flutter.dev/docs/get-started/install/windows)
2. Click **Download Flutter SDK** — you get a `.zip` file
3. Extract it to `C:\flutter` (avoid paths with spaces like `C:\Program Files`)
4. Verify the folder exists: `C:\flutter\bin\flutter.bat`

### Step 2 — Add Flutter to PATH

1. Press **Windows key**, search for "environment variables", open **Edit the system environment variables**
2. Click **Environment Variables…**
3. Under **User variables**, select **Path** → click **Edit**
4. Click **New** → type `C:\flutter\bin` → click **OK** on all dialogs
5. Open a **new** Command Prompt or PowerShell (close the old one — it won't see the new PATH)

### Step 3 — Verify the installation

In the new terminal, run:
```
flutter doctor
```

You will see a checklist. It's OK if some items show warnings — we'll fix them as we go. You need at least:
- `[✓] Flutter` — SDK found
- `[✓] Android toolchain` (or we'll set this up next)

### Step 4 — Install VS Code

1. Download from [code.visualstudio.com](https://code.visualstudio.com)
2. Run the installer with default options
3. Open VS Code

### Step 5 — Install VS Code extensions

1. Click the **Extensions** icon in the left sidebar (or press `Ctrl+Shift+X`)
2. Search for **Flutter** → click **Install** (this also installs Dart automatically)
3. Restart VS Code when prompted

### Step 6 — Install Android Studio + emulator

1. Download from [developer.android.com/studio](https://developer.android.com/studio)
2. Run the installer with default options — this installs Android Studio and the Android SDK
3. Open Android Studio → click **More Actions** → **Virtual Device Manager**
4. Click **Create device** → choose **Pixel 6** → click **Next**
5. Select a system image — pick **API 34** (Android 14) → click **Download** if needed → **Next** → **Finish**
6. Click the **▶ play button** next to your new device to start the emulator

### Step 7 — Run flutter doctor again

```
flutter doctor
```

All major items should now show `[✓]`. If you see:
- `[!] Android licenses` → run `flutter doctor --android-licenses` and accept all

### Step 8 — Open the starter project

1. Open VS Code
2. Go to **File → Open Folder** → select the `starter/` folder from this repository
3. Open the terminal in VS Code: **Terminal → New Terminal**
4. Run:
```
flutter pub get
flutter run
```

5. Select your emulator when prompted. The app should launch in about 30–60 seconds on first build.

---

## macOS

### Step 1 — Install Flutter via Homebrew (recommended)

Open **Terminal** (press `Cmd+Space`, type "Terminal") and run:

```bash
brew install --cask flutter
```

If you don't have Homebrew installed first:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2 — Verify the installation

```bash
flutter doctor
```

### Step 3 — Install VS Code

1. Download from [code.visualstudio.com](https://code.visualstudio.com)
2. Move it to your Applications folder
3. Open VS Code

### Step 4 — Install VS Code extensions

1. Press `Cmd+Shift+X` → search **Flutter** → Install

### Step 5 — Set up a device (choose one)

**Option A — Android emulator (same steps as Windows above):**
Install Android Studio from [developer.android.com/studio](https://developer.android.com/studio), then follow Steps 6–7 from the Windows guide.

**Option B — iOS Simulator (macOS only):**
1. Install Xcode from the Mac App Store (large download — ~10 GB)
2. Run: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
3. Accept the license: `sudo xcodebuild -license accept`
4. Open Simulator: `open -a Simulator`

**Option C — Physical Android device** (see section below)

**Option D — Physical iOS device (iPhone/iPad):**
1. Install Xcode from the Mac App Store
2. Connect your iPhone/iPad with a USB cable
3. On the device: tap **Trust** on the "Trust This Computer?" prompt
4. Open Xcode → **Xcode → Settings → Accounts** → add your Apple ID
5. In Xcode: open any project → select your device as the target → click **▶ Run** once (this registers a free provisioning profile)
6. On the device: go to **Settings → General → VPN & Device Management** → trust your developer certificate
7. Back in VS Code: run `flutter devices` — your iPhone should appear
8. Run `flutter run` and select your device

### Step 6 — Open and run the starter project

```bash
cd path/to/starter
flutter pub get
flutter run
```

---

## Connecting a physical Android device

If you have an Android phone and want to run the app directly on it:

1. On your phone: go to **Settings → About phone** → tap **Build number** 7 times (enables Developer Options)
2. Go to **Settings → Developer options** → enable **USB debugging**
3. Connect the phone to your laptop with a USB cable
4. On the phone: tap **Allow** on the "Allow USB debugging?" prompt
5. In your terminal: run `flutter devices` — your phone should appear in the list
6. Run `flutter run` — select your phone

---

## Understanding `flutter doctor` output

| Symbol | Meaning |
|--------|---------|
| `[✓]` | Everything OK |
| `[!]` | Warning — may affect some features |
| `[✗]` | Error — needs to be fixed |

**Common warnings you can ignore for this course:**
- `[!] Xcode` — only needed for iOS; Android works without it
- `[!] Chrome` — only needed for web development
- `[!] VS Code (version)` — if VS Code works, this is fine

**Warnings that need fixing:**
- `[✗] Flutter` → Flutter SDK not in PATH → see Step 2 above
- `[✗] Android toolchain` → Android SDK not installed → install Android Studio
- `[!] Android licenses` → run `flutter doctor --android-licenses`

---

## Verify everything works

Run the starter project. You should see:

- The app launches on the emulator/device
- The screen shows a purple "+" button and an empty state message
- Editing `lib/screens/home_screen.dart` and saving triggers hot reload (the app updates without restarting)

If you see **"No devices found"** — make sure the emulator is running before you run `flutter run`.

If you see a **Gradle error** on first build — wait a moment and try `flutter run` again. The first build downloads dependencies and can take 2–3 minutes.
