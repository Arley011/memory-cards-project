# Stage 2 — Create Entry Flow

## Today's goal
Add a "Create Entry" screen, connect it to the feed, and make new entries appear in the list immediately.

## What the app will look like at the end
Tapping the "+" button opens a new screen with a title field, a text field, and a date selector. Tapping "Save" closes the screen and the new entry appears at the top of the feed.

## Minimum required outcome (checkpoint)
- [ ] Tapping "+" opens the Create Entry screen
- [ ] The screen has a title input field and a text input field
- [ ] The user can pick a date (date picker or manual input)
- [ ] Tapping "Save" returns to the feed
- [ ] The new entry is visible at the top of the feed immediately
- [ ] Basic validation: title cannot be empty

---

## Step-by-step guide

### Step 1: Create the new screen file
Create a new file: `lib/screens/create_entry_screen.dart`

Copy the following code into the new file:

```dart
import 'package:flutter/material.dart';
import '../models/entry.dart';

class CreateEntryScreen extends StatefulWidget {
  const CreateEntryScreen({super.key});

  @override
  State<CreateEntryScreen> createState() => _CreateEntryScreenState();
}

class _CreateEntryScreenState extends State<CreateEntryScreen> {
  // TODO: add controllers and state here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Memory')),
      body: const Center(child: Text('Form goes here')),
    );
  }
}
```

> **Tip:** In VS Code, right-click the `lib/screens/` folder in the sidebar → **New File** → type `create_entry_screen.dart`.

---

### Step 2: Add text controllers
A `TextEditingController` connects a `TextField` widget to the text the user types.

Add two controllers in `_CreateEntryScreenState`, replacing the `// TODO` comment:
```dart
final _titleController = TextEditingController();
final _textController = TextEditingController();
```

**Important:** controllers must be cleaned up when the screen closes. Add the `dispose` method right after the controller lines:
```dart
final _titleController = TextEditingController();
final _textController = TextEditingController();

@override
void dispose() {
  _titleController.dispose();
  _textController.dispose();
  super.dispose();
}
```

> **Reference:** [../examples/04_forms/form_demo.dart](../examples/04_forms/form_demo.dart)

---

### Step 3: Build the form
Replace the `body` line (`body: const Center(child: Text('Form goes here')),`) with a form layout using `Padding` + `Column` + two `TextField` widgets:

```dart
body: Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _textController,
        decoration: const InputDecoration(
          labelText: 'What happened?',
          border: OutlineInputBorder(),
        ),
        maxLines: 5,
      ),
    ],
  ),
),
```

Save and hot reload — you should see two input fields on the screen.

---

### Step 4: Add a date picker
Add a `DateTime` state variable next to the controllers (before the `dispose` method):
```dart
DateTime _selectedDate = DateTime.now();
```

Then add a date picker button inside the `children` list, after the text field's `SizedBox`:
```dart
const SizedBox(height: 16),
TextButton.icon(
  onPressed: () async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  },
  icon: const Icon(Icons.calendar_today),
  label: Text('Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
),
```

Save and try it — tapping the date button should open a calendar picker.

---

### Step 5: Save and return
Add a save button to the `AppBar`. Change the `appBar` line to:
```dart
appBar: AppBar(
  title: const Text('New Memory'),
  actions: [
    TextButton(
      onPressed: _save,
      child: const Text('Save'),
    ),
  ],
),
```

Now write the `_save` method. Add it inside the `_CreateEntryScreenState` class, before the `build` method:
```dart
void _save() {
  final title = _titleController.text.trim();
  if (title.isEmpty) {
    // Show an error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Title cannot be empty')),
    );
    return;
  }

  final newEntry = Entry(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    title: title,
    text: _textController.text.trim(),
    date: _selectedDate,
  );

  Navigator.pop(context, newEntry); // Return the entry to the previous screen
}
```

---

### Step 6: Connect the screens
Now we need to make the "+" button in `home_screen.dart` open the new screen.

1. Add this import at the top of `home_screen.dart` (both files are in the same `screens/` folder, so no `../` is needed):
```dart
import 'create_entry_screen.dart';
```

2. Find the `onPressed` callback on the `FloatingActionButton`. Replace the **entire callback** (including the commented-out example code) with:
```dart
onPressed: () async {
  final newEntry = await Navigator.push<Entry>(
    context,
    MaterialPageRoute(builder: (_) => const CreateEntryScreen()),
  );
  if (newEntry != null) {
    setState(() => _entries.insert(0, newEntry)); // Insert at the top
  }
},
```

> **Important:** Notice the `async` keyword after `()` — this is required because `await` pauses the code until the Create screen closes and returns a result.

> **Reference:** [../examples/03_navigation/](../examples/03_navigation/) — see how Screen A opens Screen B and gets a value back

---

## Optional extensions
- Add a "Cancel" button in the AppBar that pops without saving
- Show a confirmation dialog if the user taps Cancel after typing something (see the cheatsheet's "Show a confirmation dialog" snippet)
- Format the date button using `DateFormat` from the `intl` package instead of the manual `day/month/year` format
- Add a character counter below the title field (hint: use `_titleController.addListener`)
- Sort the feed newest-first after every save (hint: `_entries.sort((a, b) => b.date.compareTo(a.date))`)

---

## Useful Flutter widgets/functions today

| Widget / concept | What it does |
|---|---|
| `StatefulWidget` | A widget that can change — holds mutable state |
| `setState(() { ... })` | Tells Flutter to rebuild the widget with new state |
| `TextEditingController` | Reads what the user typed in a `TextField` |
| `TextField` | A text input field |
| `InputDecoration` | Adds label, border, hint to a `TextField` |
| `showDatePicker(...)` | Opens the system date picker dialog |
| `Navigator.push(context, route)` | Opens a new screen |
| `Navigator.pop(context, value)` | Closes the screen and optionally returns a value |
| `await` | Waits for an async result (e.g., screen closes, date picked) |
| `async` | Marks a function that uses `await` — always used together |
| `ScaffoldMessenger.of(context).showSnackBar(...)` | Shows a brief message at the bottom |
