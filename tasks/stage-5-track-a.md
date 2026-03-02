# Stage 5 — Track A: Photo Attachment

## Today's goal
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

---

### Step 2: Add state for the image
In `_CreateEntryScreenState`, add:
```dart
String? _imagePath;
```

---

### Step 3: Add the photo picker button
Import at the top of `create_entry_screen.dart`:
```dart
import 'package:image_picker/image_picker.dart';
import 'dart:io';
```

Add a method to pick a photo:
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

Add the button + preview to the form body:
```dart
const SizedBox(height: 16),
if (_imagePath != null)
  ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.file(
      File(_imagePath!),
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    ),
  )
else
  OutlinedButton.icon(
    onPressed: _pickPhoto,
    icon: const Icon(Icons.photo_library),
    label: const Text('Add Photo'),
  ),
if (_imagePath != null)
  TextButton(
    onPressed: () => setState(() => _imagePath = null),
    child: const Text('Remove photo'),
  ),
```

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
In `entry_card.dart`, add the photo at the top of the `Column`:

```dart
if (entry.imagePath != null)
  ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
    child: Image.file(
      File(entry.imagePath!),
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
    ),
  ),
```

Add the import at the top of `entry_card.dart`:
```dart
import 'dart:io';
```

---

## Optional extensions
- Add a second button to take a photo with the camera (`ImageSource.camera`)
- Show the photo in full screen when tapped (`Navigator.push` with a new screen that shows `Image.file`)
- Allow replacing the photo (show the picker button even when a photo is already selected)
- Add a caption field that appears only when a photo is attached

---

## Useful Flutter widgets/functions today

| Widget / concept | What it does |
|---|---|
| `ImagePicker().pickImage(source: ...)` | Opens gallery or camera and returns the image path |
| `ImageSource.gallery` / `ImageSource.camera` | Where to pick the image from |
| `Image.file(File(path))` | Displays an image from a local file path |
| `File(path)` | Wraps a file path for use with `Image.file` |
| `ClipRRect` | Clips a child widget with rounded corners |
| `BoxFit.cover` | Fills the space while keeping aspect ratio (may crop) |
| `imageQuality: 80` | Compress the image to reduce file size |
