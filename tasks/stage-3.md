# Stage 3 — Persistence (Save Data Locally)

> **Before you start:** Make sure Stage 2 is working — you can tap "+", fill in a title and text, tap "Save", and see the new entry appear in the feed.

## Goal
Make entries survive app restarts by saving them to the device, and add the ability to delete entries.

## What the app will look like at the end
Closing and reopening the app shows the same entries as before. Swiping a card to the left shows a red delete background and a confirmation dialog. After deleting, the entry is gone — even after restart.

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

### How persistence works

```
App starts
    │
    ↓
loadEntries()  →  SharedPreferences  →  _entries list  →  UI shows cards
                    (device storage)

User creates entry
    │
    ├──→ _entries.insert()  →  setState()  →  UI updates instantly
    │
    └──→ saveEntries()  →  SharedPreferences  →  saved to device

App restarts  →  loadEntries()  →  same data is back!
```

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
You'll need to import the storage functions you just created. Type `loadEntries` in your code and press **Alt+Enter** — Android Studio will suggest the correct import.

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

### Step 6: Add delete with swipe

Flutter has a built-in widget called `Dismissible` that lets users swipe items to delete them — much more intuitive than a long-press!

**In `home_screen.dart`**, wrap the `EntryCard` inside the `ListView.builder`'s `itemBuilder` with a `Dismissible` widget:

```dart
Dismissible(
  // Each Dismissible needs a unique key so Flutter knows which item is being swiped
  key: ValueKey(_entries[index].id),
  // Only allow swiping from right to left
  direction: DismissDirection.endToStart,
  // The red background that appears when swiping
  background: Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 16),
    child: const Icon(Icons.delete, color: Colors.white),
  ),
  // Ask for confirmation before actually deleting
  confirmDismiss: (direction) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  },
  // This runs after the user confirms deletion
  onDismissed: (direction) {
    setState(() => _entries.removeAt(index));
    saveEntries(_entries);
  },
  child: EntryCard(entry: _entries[index]),
)
```

> **Why `ValueKey`?** When you swipe an item, Flutter needs to know exactly which widget is being removed. The `key` parameter gives each `Dismissible` a unique identity — we use the entry's `id` for this.

> **What is `confirmDismiss`?** It's a callback that must return `true` (proceed with delete) or `false` (cancel). We use `showDialog` to ask the user first. The `?? false` at the end means "if the dialog is dismissed without a choice, treat it as cancel."

> **Reference:** [../examples/06_list_crud/list_crud_demo.dart](../examples/06_list_crud/list_crud_demo.dart)

---

## Optional extensions
- Show a `SnackBar` with an "Undo" action after deleting — restore the entry if the user taps Undo before the SnackBar disappears
- Add a "Clear all" button in the AppBar with a confirmation dialog
- Show a loading indicator (`CircularProgressIndicator`) while entries are being loaded from storage
- **Add to favorites (challenge):** Use `Dismissible` with `DismissDirection.horizontal` to support swiping in **both** directions — swiping right-to-left deletes (red background, delete icon), swiping left-to-right toggles a "favorite" status (gold/yellow background, star icon). To make this work you will need to:
  - Add an `isFavorite` field to the `Entry` model (don't forget `toJson`, `fromJson`, and `copyWith`)
  - Show a small star icon on favorited cards
  - Explore how `confirmDismiss` can return `false` to prevent the item from being removed (for the favorite action — you want to keep the card, just toggle the flag)

---

## Useful Flutter widgets/functions

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
| `Dismissible` | Wraps a widget to make it swipeable (for delete, archive, etc.) |
| `ValueKey(value)` | Gives a widget a unique identity — required by `Dismissible` |
| `showDialog(...)` | Shows a modal dialog and returns a value when closed |
| `AlertDialog` | A standard confirm/cancel dialog |
