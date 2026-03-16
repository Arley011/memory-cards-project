# Environment Setup Guide

This guide walks you through installing everything you need to run Flutter apps on your Mac laptop.

**What you will install:**
- Flutter SDK (the framework)
- Android Studio + Flutter plugin (the code editor)
- Android emulator (a virtual phone to test your app on)

---

## Step 1 — Install Android Studio

1. Download from [developer.android.com/studio](https://developer.android.com/studio)
2. Open the downloaded file and drag Android Studio into your Applications folder
3. Open Android Studio
4. Complete the **initial setup wizard** — click through with the default options. This automatically downloads the Android SDK (a large download, be patient)

> **Note:** The setup wizard may take several minutes. It downloads a lot of files. Make sure you have a stable internet connection.

---

## Step 2 — Install the Flutter plugin

1. Open Android Studio
2. Go to **Android Studio → Settings** (or **Preferences** on some macOS versions)
3. Click **Plugins** in the left sidebar
4. Search for **Flutter** → click **Install**
5. When prompted, also install the **Dart** plugin (it will ask automatically)
6. Click **Restart IDE** to restart Android Studio

> **Tip:** After restarting, you should see a "New Flutter Project" option on the welcome screen. That means the plugin is working.

---

## Step 3 — Install Flutter SDK

**Option A — via Homebrew (recommended):**

Open Terminal (you can find it in Applications → Utilities → Terminal) and run:
```bash
brew install --cask flutter
```

> **Don't have Homebrew?** Open Terminal and paste this command first:
> ```bash
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
> ```
> Then run the `brew install --cask flutter` command above.

**Option B — manual download:**

1. Go to [flutter.dev/docs/get-started/install/macos](https://flutter.dev/docs/get-started/install/macos)
2. Download the Flutter SDK zip file
3. Unzip it to a folder like `~/flutter`
4. Add Flutter to your PATH so your terminal can find it. Open Terminal and run:
```bash
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

## Step 4 — Set up a device (choose one)

You need something to run your app on. Pick one of these options:

**Option A — Android emulator (recommended for this course):**

1. Open Android Studio
2. Go to **Tools → Device Manager**
3. Click **Create Device**
4. Choose a phone — pick **Pixel 8** → click **Next**
5. Select a system image — pick the **recommended** one (it will be highlighted) → click **Download** if needed → wait for the download → click **Next** → click **Finish**
6. Click the **▶ play button** next to your new device to start the emulator
7. A virtual phone should appear on your screen — this is where your app will run!

**Option B — iOS Simulator:**

1. Install **Xcode** from the Mac App Store (large download — ~10 GB)
2. Open Terminal and run these two commands:
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
```
3. Open the Simulator:
```bash
open -a Simulator
```

**Option C — Physical Android device** (see the "Connecting a physical Android device" section below)

**Option D — Physical iPhone/iPad:**
This requires Xcode, a USB cable, and some extra configuration (provisioning profiles). Ask your mentor if you'd like to try this.

---

## Step 5 — Verify the installation

1. Open Android Studio
2. Go to **View → Tool Windows → Terminal** to open the built-in terminal
3. Run:
```bash
flutter doctor -v
```

This shows a checklist of everything Flutter needs. You should see:
- `[✓] Flutter` — the SDK is installed and working
- `[✓] Android toolchain` — Android SDK is ready
- `[✓] Android Studio` — your editor is detected

If you see:
- `[!] Android licenses` → run `flutter doctor --android-licenses` and type **y** to accept each one
- Other warnings about Xcode or Chrome → you can ignore these for now (see the table below)

---

## Step 6 — Open the starter project

1. Open Android Studio
2. Go to **File → Open**
3. Navigate to and select the `starter/` folder from this repository → click **Open**
4. Wait for **Gradle sync** to finish — you'll see a progress bar at the bottom. This can take a minute or two on the first time
5. In the toolbar at the top, find the **device dropdown** and select your emulator (or connected phone)
6. Click the green **Run button (▶)** in the toolbar

The app should launch in about 30–60 seconds on the first build.

**Alternative — using the terminal:**

You can also run the project from the terminal inside Android Studio (**View → Tool Windows → Terminal**):
```bash
flutter pub get
flutter run
```

If prompted to choose a device, select the emulator, simulator, or your phone name.

> **Trouble?** If `flutter pub get` fails with a network error, you may be behind a firewall or proxy. Ask your mentor for help.

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

**Warnings that need fixing:**
- `[✗] Flutter` → Flutter SDK not found → reinstall following Step 3 above
- `[✗] Android toolchain` → Android SDK not installed → install Android Studio (Step 1)
- `[!] Android licenses` → run `flutter doctor --android-licenses` and type **y** to accept each one

---

## Verify everything works

Run the starter project. You should see:

- The app launches on the emulator/device
- The screen shows a purple "+" button and an empty state message
- Editing `lib/screens/home_screen.dart` triggers hot reload automatically (Android Studio saves files automatically) — the app updates without restarting

---

## Common issues

- **"No devices found"** → make sure the emulator is running before you click Run or run `flutter run`
- **Gradle error on first build** → wait a moment and try again. The first build downloads dependencies and can take 2–3 minutes.
- **Network/proxy errors during `flutter pub get`** → ask your mentor for help configuring proxy settings
