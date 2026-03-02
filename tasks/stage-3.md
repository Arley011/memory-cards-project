# Stage 3 — Persistence (Save Data Locally)

> **Before you start:** Make sure Stage 2 is working — you can tap "+", fill in a title and text, tap "Save", and see the new entry appear in the feed.

## Today's goal
Make entries survive app restarts by saving them to the device, and add the ability to delete entries.

## What the app will look like at the end
Closing and reopening the app shows the same entries as before. Long-pressing a card shows a delete confirmation dialog. After deleting, the entry is gone — even after restart.

## Minimum required outcome (checkpoint)
- [ ] Entries are saved automatically every time the list changes
- [ ] On app start, previously saved entries are loaded and shown in the feed
- [ ] Deleting an entry works (at least one method: long-press, swipe, or button)
- [ ] Deleted entries do not reappear after restart

---

## Step-by-step guide

### Step 1: Understand the storage approach
We use `shared_preferences` — a simple key-value store that lives on the device.

The whole entry list is stored under a single key `'entries'`, as a list of JSON strings:
```
'entries' → ["{"id":"1","title":"Arrived at Gut Wehlitz",...}", "{"id":"2",...}"]
```

Each Entry is converted to/from JSON using the `toJson()` and `fromJson()` methods already in `entry.dart`.

---

### Step 2: Create the storage helper
Create a new file: `lib/utils/storage.dart`

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entry.dart';

const _key = 'entries';

// Save the full list of entries to the device
Future<void> saveEntries(List<Entry> entries) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonList = entries.map((e) => jsonEncode(e.toJson())).toList();
  await prefs.setStringList(_key, jsonList);
}

// Load the full list of entries from the device
Future<List<Entry>> loadEntries() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonList = prefs.getStringList(_key) ?? [];
  return jsonList.map((s) => Entry.fromJson(jsonDecode(s))).toList();
}
```

> **Note:** `dart:convert` provides `jsonEncode` and `jsonDecode`. `shared_preferences` is already in `pubspec.yaml`.

> **Reference:** [../examples/05_persistence/persistence_demo.dart](../examples/05_persistence/persistence_demo.dart)

---

### Step 3: Switch from sample data to storage
In `home_screen.dart`, add an import:
```dart
import '../utils/storage.dart';
```

Now change the `_entries` variable. Remove `final` (because we'll reassign it when loading from storage) and start with an empty list:
```dart
// Before (from Stage 1):
final List<Entry> _entries = List.from(sampleEntries);

// After:
List<Entry> _entries = [];
```

> **Note:** You can keep the `import '../data/sample_entries.dart';` line — you'll need it again in Stage 4 for the tag list.

---

### Step 4: Save after every change
Every time `_entries` changes, call `saveEntries`. In the FAB `onPressed` callback (where you add a new entry), add a save call right after the `setState`:
```dart
setState(() => _entries.insert(0, newEntry));
saveEntries(_entries); // Save after adding
```

> **Note:** You don't need `await` here — the save can happen in the background while the UI updates.

---

### Step 5: Load entries when the app starts
Override `initState` to load entries when the screen first appears. Add this inside `_HomeScreenState`, before the `build` method:
```dart
@override
void initState() {
  super.initState();
  _loadFromStorage();
}

Future<void> _loadFromStorage() async {
  final saved = await loadEntries();
  setState(() => _entries = saved);
}
```

Now test it: run the app, create an entry, **close the app completely** (stop it in the terminal), then run it again. Your entry should still be there!

> **Note:** Any entries you created in Stage 2 won't appear — they were only in memory and never saved to storage. Create new ones and they'll persist from now on.

> **Hint:** `initState` runs once when the widget is inserted into the widget tree.

---

### Step 6: Add delete
Add a long-press handler to the `EntryCard` widget so users can delete entries.

**In `entry_card.dart`**, add a callback parameter to `EntryCard`:
```dart
final VoidCallback? onDelete;
const EntryCard({super.key, required this.entry, this.onDelete});
```

Wrap the `Card` with `GestureDetector`:
```dart
GestureDetector(
  onLongPress: onDelete,
  child: Card(...),  // your existing Card widget
)
```

**In `home_screen.dart`**, pass a delete callback when creating `EntryCard`:
```dart
EntryCard(
  entry: _entries[index],
  onDelete: () => _deleteEntry(index),
)
```

Add the `_deleteEntry` method in `_HomeScreenState`:
```dart
void _deleteEntry(int index) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete entry?'),
      content: const Text('This cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
      ],
    ),
  );
  if (confirm == true) {
    setState(() => _entries.removeAt(index));
    saveEntries(_entries);
  }
}
```

> **Reference:** [../examples/06_list_crud/list_crud_demo.dart](../examples/06_list_crud/list_crud_demo.dart)

---

## Optional extensions
- Show a `SnackBar` with an "Undo" action after deleting (restore the entry if the user taps Undo)
- Add swipe-to-delete using the `Dismissible` widget (see `examples/06_list_crud`)
- Add a "Clear all" button in the AppBar with a confirmation dialog
- Show a loading indicator (`CircularProgressIndicator`) while entries are being loaded from storage
- Improve the Entry model: ensure the `id` is truly unique even if two entries are created within the same millisecond

---

## Useful Flutter widgets/functions today

| Widget / concept | What it does |
|---|---|
| `SharedPreferences.getInstance()` | Gets access to the device's key-value store |
| `prefs.setStringList(key, list)` | Saves a list of strings |
| `prefs.getStringList(key)` | Reads a list of strings (returns null if not set) |
| `jsonEncode(map)` | Converts a Map to a JSON String |
| `jsonDecode(string)` | Converts a JSON String back to a Map |
| `initState()` | Called once when a StatefulWidget is first created |
| `Future<T>` | A value that will be available in the future (async result) |
| `async` / `await` | Write async code that reads like normal code |
| `GestureDetector` | Detects taps, long-presses, swipes on any widget |
| `showDialog(...)` | Shows a modal dialog and returns a value when closed |
| `AlertDialog` | A standard confirm/cancel dialog |
