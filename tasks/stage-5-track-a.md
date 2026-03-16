# Stage 5 — Track A: Photo Attachment

## Goal
Allow users to attach a photo to a memory entry, and show a thumbnail on the card.

## What the app will look like at the end
The Create Entry screen has an "Add Photo" button. When tapped, the device gallery opens. After selecting a photo, a preview is shown in the form. The entry card in the feed displays the photo thumbnail at the top of the card.

## Minimum required outcome (checkpoint)
- [ ] "Add Photo" button opens the gallery
- [ ] Selected photo appears as a preview in the form
- [ ] Photo path is saved with the entry
- [ ] Entry card shows the photo thumbnail

---

## Step-by-step guide

### Step 1: Required permissions

**Android** — open `starter/android/app/src/main/AndroidManifest.xml` and add inside the `<manifest>` tag (before `<application>`):
```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

**iOS** — open `starter/ios/Runner/Info.plist` and add inside the `<dict>` tag:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to attach images to your memories.</string>
```

> **Note:** `READ_MEDIA_IMAGES` works on Android 13+. If you're testing on an older Android version, use `READ_EXTERNAL_STORAGE` instead.

---

### Step 2: Add state for the image
In `_CreateEntryScreenState`, add this next to the other state variables (controllers, date, tags):
```dart
String? _imagePath;
```

---

### Step 3: Add the photo picker
You'll need to import `image_picker` and `dart:io` — when Android Studio shows red underlines on `ImagePicker` or `File`, press **Alt+Enter** to auto-import them.

Add a method to pick a photo inside `_CreateEntryScreenState`, before the `build` method:
```dart
Future<void> _pickPhoto() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80, // Compress slightly to save storage
  );
  if (picked != null) {
    setState(() => _imagePath = picked.path);
  }
}
```

Now add a section in your form's `Column` (after the tag chips, or after the date picker if you skipped Stage 4) that shows either a photo preview or an "Add Photo" button. Build this yourself using these hints:

> **Hint 1:** Use an `if (_imagePath != null) ... else ...` pattern — same conditional widget logic you used in earlier stages.

> **Hint 2:** For the preview, use `Image.file(File(_imagePath!))` wrapped in `ClipRRect` for rounded corners. Set `height: 200`, `width: double.infinity`, `fit: BoxFit.cover`.

> **Hint 3:** For the button, use `OutlinedButton.icon` with `Icons.photo_library` as the icon and `'Add Photo'` as the label. Call `_pickPhoto` when pressed.

> **Hint 4:** Add a "Remove photo" `TextButton` below the preview so users can change their mind — it should set `_imagePath` back to `null` using `setState`.

---

### Step 4: Save the image path
Update `_save()` to pass the image path:
```dart
final newEntry = Entry(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  title: title,
  text: _textController.text.trim(),
  date: _selectedDate,
  tags: _selectedTags.toList(),
  imagePath: _imagePath, // Add this line
);
```

---

### Step 5: Show thumbnail on the card
Add the photo as the first item in the card's `Column`, before the title. When Android Studio shows a red underline on `File`, press **Alt+Enter** to import `dart:io`.

Build this yourself using these hints:

> **Hint 1:** Use `if (entry.imagePath != null) ...[...]` for conditional rendering — this is the same spread pattern you used for tags in Stage 4.

> **Hint 2:** Use `Image.file`, `ClipRRect`, and `BoxFit.cover` — the same approach as the preview in the form. Use a `height` of `160` and `width: double.infinity`.

> **Hint 3:** Add a `SizedBox(height: 8)` after the image to add spacing before the title.

> **Note:** The image will be slightly inset because it's inside the card's `Padding`. That's fine! If you want an edge-to-edge image, you would need to restructure the card layout — try this as a challenge if you finish early.

---

## Optional extensions
- Add a second button to take a photo with the camera (`ImageSource.camera`) — does it work on the emulator?
- Add a "pinch to zoom" on the photo when tapped (hint: open a new screen with `InteractiveViewer` widget wrapping the full-size image)
- Show a placeholder icon (like `Icons.image_outlined`) on cards that have no photo, to visually distinguish them
- Allow replacing the photo (show the picker button even when a photo is already selected)
- Add a caption field that appears only when a photo is attached

---

## Useful Flutter widgets/functions

| Widget / concept | What it does |
|---|---|
| `ImagePicker().pickImage(source: ...)` | Opens gallery or camera and returns the image path |
| `ImageSource.gallery` / `ImageSource.camera` | Where to pick the image from |
| `Image.file(File(path))` | Displays an image from a local file path |
| `File(path)` | Wraps a file path for use with `Image.file` |
| `ClipRRect` | Clips a child widget with rounded corners |
| `BoxFit.cover` | Fills the space while keeping aspect ratio (may crop) |
| `imageQuality: 80` | Compress the image to reduce file size |
