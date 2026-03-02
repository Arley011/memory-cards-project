# Environment Setup Guide

This guide walks you through installing everything you need to run Flutter apps on your laptop.

**What you will install:**
- Flutter SDK (the framework)
- VS Code (the code editor)
- Dart & Flutter extensions for VS Code
- Android Studio + an Android emulator (or a physical Android device)

---

## Windows

### Step 1 — Install VS Code

1. Download from [code.visualstudio.com](https://code.visualstudio.com)
2. Run the installer with default options
3. Open VS Code

### Step 2 — Install Flutter via VS Code (recommended)

1. Click the **Extensions** icon in the left sidebar (or press `Ctrl+Shift+X`)
2. Search for **Flutter** → click **Install** (this also installs Dart automatically)
3. Restart VS Code when prompted
4. Open the Command Palette: press `Ctrl+Shift+P`
5. Type **Flutter: New Project** and select it
6. VS Code will ask you to locate the Flutter SDK — click **Download SDK**
7. Choose a location like `C:\flutter` (avoid paths with spaces like `C:\Program Files`)
8. Wait for the download to finish (this may take a few minutes)
9. Click **Add SDK to PATH** when prompted

### Step 3 — Verify the installation

Open a **new** terminal in VS Code (**Terminal → New Terminal**) and run:
```
flutter doctor -v
```

You will see a checklist. It's OK if some items show warnings — we'll fix them as we go. You need at least:
- `[✓] Flutter` — SDK found
- `[✓] Android toolchain` (or we'll set this up next)

### Step 4 — Install Android Studio + emulator

1. Download from [developer.android.com/studio](https://developer.android.com/studio)
2. Run the installer with default options — this installs Android Studio and the Android SDK
3. Open Android Studio → click **More Actions** → **Virtual Device Manager**
4. Click **Create device** → choose any phone (e.g. **Pixel 8**) → click **Next**
5. Select a system image — pick the recommended one (usually the latest) → click **Download** if needed → **Next** → **Finish**
6. Click the **▶ play button** next to your new device to start the emulator

### Step 5 — Run flutter doctor again

```
flutter doctor
```

All major items should now show `[✓]`. If you see:
- `[!] Android licenses` → run `flutter doctor --android-licenses` and type **y** to accept each one

### Step 6 — Open the starter project

1. Open VS Code
2. Go to **File → Open Folder** → select the `starter/` folder from this repository
3. Open the terminal in VS Code: **Terminal → New Terminal**
4. Run:
```
flutter pub get
flutter run
```

5. If prompted to choose a device, select the one that says "emulator" or "android".
6. The app should launch in about 30–60 seconds on first build.

> **Trouble?** If `flutter pub get` fails with a network error, you may be behind a firewall or proxy. Ask your mentor for help.

---

## macOS

### Step 1 — Install VS Code

1. Download from [code.visualstudio.com](https://code.visualstudio.com)
2. Move it to your Applications folder
3. Open VS Code

### Step 2 — Install Flutter

**Option A — via VS Code (recommended):**
1. Press `Cmd+Shift+X` → search **Flutter** → Install (this also installs Dart)
2. Restart VS Code
3. Press `Cmd+Shift+P` → type **Flutter: New Project** → select it
4. Click **Download SDK** → choose a folder → wait for the download
5. Click **Add SDK to PATH** when prompted

**Option B — via Homebrew:**
```bash
brew install --cask flutter
```
Then install the Flutter extension in VS Code: press `Cmd+Shift+X` → search **Flutter** → Install.

### Step 3 — Verify the installation

Open a terminal and run:
```bash
flutter doctor -v
```

### Step 4 — Set up a device (choose one)

**Option A — Android emulator (recommended for this course):**
Install Android Studio from [developer.android.com/studio](https://developer.android.com/studio), then follow Steps 4–5 from the Windows guide above.

**Option B — iOS Simulator (macOS only):**
1. Install Xcode from the Mac App Store (large download — ~10 GB)
2. Open Terminal and run:
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
```
3. Open Simulator: `open -a Simulator`

**Option C — Physical Android device** (see section below)

**Option D — Physical iPhone/iPad:**
This requires Xcode, a USB cable, and some extra configuration. Ask your mentor if you'd like to try this — it takes a few extra steps to set up provisioning profiles.

### Step 5 — Open and run the starter project

```bash
cd path/to/starter
flutter pub get
flutter run
```

If prompted to choose a device, select the emulator, simulator, or your phone name.

---

## Connecting a physical Android device

If you have an Android phone and want to run the app directly on it:

1. On your phone: go to **Settings → About phone** → tap **Build number** 7 times (this enables Developer Options)
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
- `[✗] Flutter` → Flutter SDK not in PATH → reinstall using VS Code (Step 2 above)
- `[✗] Android toolchain` → Android SDK not installed → install Android Studio
- `[!] Android licenses` → run `flutter doctor --android-licenses` and type **y** to accept each one

---

## Verify everything works

Run the starter project. You should see:

- The app launches on the emulator/device
- The screen shows a purple "+" button and an empty state message
- Editing `lib/screens/home_screen.dart` and saving triggers hot reload (the app updates without restarting)

**Common issues:**
- **"No devices found"** → make sure the emulator is running before you run `flutter run`
- **Gradle error on first build** → wait a moment and try `flutter run` again. The first build downloads dependencies and can take 2–3 minutes.
- **Network/proxy errors during `flutter pub get`** → ask your mentor for help configuring proxy settings
