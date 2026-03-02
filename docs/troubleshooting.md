# Troubleshooting Guide

Common problems and how to fix them. Start with the error message in the VS Code terminal or the Problems panel.

---

## Setup issues

### 1. `flutter: command not found`

**Symptom:** Running `flutter doctor` or `flutter run` in the terminal says "command not found" or "is not recognized".

**Fix:**
1. Make sure you added `C:\flutter\bin` (Windows) or the Flutter bin path (macOS) to your PATH
2. **Close and reopen your terminal** — PATH changes only apply to new terminal sessions
3. Verify: `echo $PATH` (macOS/Linux) or `echo %PATH%` (Windows) — you should see flutter\bin in the output
4. If still not found on macOS: `which flutter` — if empty, try `brew install --cask flutter` again

---

### 2. `flutter doctor` shows Android SDK missing

**Symptom:** `[✗] Android toolchain - develop for Android devices` with "Android SDK not found".

**Fix:**
1. Open **Android Studio**
2. Go to **More Actions → SDK Manager** (or Settings → Android SDK)
3. Make sure **Android SDK** is installed (check the SDK Platforms tab)
4. Note the **Android SDK Location** path shown at the top
5. Run `flutter config --android-sdk /path/to/sdk` with that path
6. Run `flutter doctor` again

---

### 3. Android emulator won't start

**Symptom:** Clicking the play button in AVD Manager does nothing, or shows "HAXM installation is required".

**Fix (Windows/Linux):**
- Enable hardware virtualisation in your BIOS/UEFI settings (look for VT-x, Intel Virtualization Technology, or AMD-V)
- Restart the computer after enabling it

**Fix (all platforms):**
- Try a different system image — use **API 33** instead of **API 34**
- Try **x86_64** image instead of **arm64**
- On macOS with Apple Silicon: use an **arm64** image

---

### 4. VS Code shows "No device detected" / "No devices found"

**Symptom:** Flutter icon in VS Code shows no devices, or `flutter run` says "No supported devices connected".

**Fix:**
1. **Start the emulator first** — it must be fully booted before VS Code detects it
2. Wait for the emulator to reach the home screen (can take 1–2 minutes on first boot)
3. If using a physical device: check USB debugging is enabled (see setup guide)
4. Run `flutter devices` in the terminal to see what Flutter can see

---

### 5. `adb: command not found` (Windows)

**Symptom:** adb-related errors when connecting a physical device.

**Fix:**
1. Find your Android SDK Platform Tools folder (usually `C:\Users\YOU\AppData\Local\Android\Sdk\platform-tools\`)
2. Add this folder to your PATH (same steps as adding Flutter to PATH)
3. Reopen the terminal

---

## Build and run issues

### 6. Gradle build failed on first run

**Symptom:** Long error message containing "Gradle" or "BUILD FAILED" when running for the first time.

**Fix:**
```bash
flutter clean
flutter pub get
flutter run
```

If that doesn't work:
- Check you have a stable internet connection (Gradle downloads dependencies)
- Make sure Android Studio is installed and Android SDK is configured
- Try `flutter doctor` to confirm Android toolchain is green

---

### 7. `MissingPluginException` for `shared_preferences`

**Symptom:** App crashes with `MissingPluginException(No implementation found for method ...)` after adding shared_preferences.

**Fix:**
1. This happens after adding a new package that has native code
2. **Hot reload is not enough** — you need a **full restart**
3. Stop the app completely (`q` in terminal or Stop in VS Code)
4. Run `flutter run` again

If still failing:
```bash
flutter clean
flutter pub get
flutter run
```

---

### 8. App crashes immediately on launch

**Symptom:** The emulator briefly shows the app then crashes to home screen.

**Fix:**
1. Look at the terminal — there will be a red error message with a stack trace
2. Find the first line that mentions YOUR file (e.g., `home_screen.dart:42`)
3. That line number tells you where the crash happened — go fix it
4. Common causes: null pointer errors, missing required field, syntax error

---

### 9. `Null check operator used on a null value`

**Symptom:** App crashes with this message. In the stack trace you'll see a line like `entry!.title`.

**What it means:** You used `!` to force-unwrap a value that turned out to be null.

**Fix:**
- Find the `!` in your code near the line in the stack trace
- Add a null check: `if (entry != null) { ... }`
- Or use the null-coalescing operator: `entry?.title ?? 'No title'`

---

### 10. Hot reload doesn't show my changes

**Symptom:** You save the file and nothing changes in the app.

**When hot reload works:** Changes to `build()` methods, widget properties, styling, text.

**When you need hot restart** (press `R` in terminal or the restart button in VS Code):
- You added a new `initState()` method
- You changed `main()` or app initialization code
- You added a new package
- State variable type changed

**When you need to fully stop and restart** (`flutter run` again):
- You added or changed native code (pubspec.yaml packages with native plugins)
- You changed `AndroidManifest.xml` or `Info.plist`

---

## Runtime and code issues

### 11. `setState() called after dispose()`

**Symptom:** Red warning in the terminal: `setState() called after dispose()`.

**What it means:** An async operation (like loading from SharedPreferences) finished after the user already navigated away from the screen.

**Fix:** Check if the widget is still mounted before calling setState:
```dart
if (mounted) {
  setState(() { ... });
}
```

---

### 12. `RenderFlex overflowed by X pixels`

**Symptom:** A yellow-and-black striped area appears on the emulator, and the terminal shows "overflowed".

**What it means:** A Row or Column is trying to fit more content than the available space.

**Fix options:**
- Wrap the overflowing child in `Flexible` or `Expanded`:
  ```dart
  Expanded(child: Text(veryLongText))
  ```
- Add `overflow: TextOverflow.ellipsis` to a Text widget
- Wrap the whole body in `SingleChildScrollView` to make it scrollable

---

### 13. Image not loading from file path

**Symptom:** `Image.file(File(path))` shows nothing or an error icon.

**Fix:**
1. Make sure you used `await` when calling `image_picker`:
   ```dart
   final picked = await picker.pickImage(...);
   ```
2. Check `picked` is not null before using `picked.path`
3. On Android: make sure you added the READ_MEDIA_IMAGES permission in AndroidManifest.xml
4. Test on a real device or emulator — simulators may have limited gallery access

---

### 14. SharedPreferences data is lost after reinstalling the app

**Symptom:** After uninstalling and reinstalling, all entries are gone.

**This is expected behaviour.** SharedPreferences stores data in the app's private storage. Uninstalling the app removes that storage.

This is how all local device storage works — it's not a bug. To keep data across reinstalls, you would need cloud storage (out of scope for this course).

---

### 15. Notification permission denied (iOS)

**Symptom:** Notifications work on Android but not on iOS simulator/device.

**Fix:**
1. Make sure `Info.plist` has the notification permission keys (see Stage 5 Track C task)
2. The first time the app tries to show a notification, iOS will ask the user for permission — the user must tap **Allow**
3. If permission was denied: go to **Settings → [Your App] → Notifications** → enable them
4. If testing on the Simulator: make sure you are running **iOS 16 Simulator or newer** (Xcode 14+) — older simulators did not support local notifications

---

## Still stuck?

1. Copy the exact error message from the terminal
2. Search it on [stackoverflow.com](https://stackoverflow.com) — most Flutter errors have been seen before
3. Check the [Flutter docs](https://docs.flutter.dev) for the specific widget or package
4. Ask your mentor
