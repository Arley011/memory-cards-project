# Stage 2 — Create Entry Flow

## Goal
Add a "Create Entry" screen, connect it to the feed, and make new entries appear in the list immediately.

## What the app will look like at the end
Tapping the "+" button opens a new screen with a title field, a text field, and a date selector. Tapping "Save" closes the screen and the new entry appears at the top of the feed.

### How the screens connect

```
  HomeScreen                          CreateEntryScreen
  ┌──────────┐    Navigator.push     ┌──────────────────┐
  │          │ ────────────────────→  │                  │
  │  Feed    │                       │  Title field     │
  │  list    │    Navigator.pop      │  Text field      │
  │          │ ←──────────────────── │  Date picker     │
  │  + FAB   │   (returns Entry)     │  Save button     │
  └──────────┘                       └──────────────────┘
       │
       ↓
  setState() → new entry appears at top of list
```

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

// There are 2 main types of widgets in Flutter: StatefulWidget and StatelessWidget.
// StatelessWidget draws UI using only the data passed to it — it cannot change.
// StatefulWidget can hold data (state) that changes over time, like form inputs.
class CreateEntryScreen extends StatefulWidget {
  const CreateEntryScreen({super.key});

  @override
  State<CreateEntryScreen> createState() => _CreateEntryScreenState();
}

// This is the State class — it holds the mutable data for the widget above.
// When you call setState(), Flutter calls build() again to redraw the screen.
class _CreateEntryScreenState extends State<CreateEntryScreen> {
  // TODO: add controllers and state here

  @override
  Widget build(BuildContext context) {
    // build() defines what this screen looks like.
    // It is called every time setState() is invoked.
    // Scaffold provides the basic app structure: AppBar at the top + body area.
    return Scaffold(
      appBar: AppBar(title: const Text('New Memory')),
      body: const Center(child: Text('Form goes here')),
    );
  }
}
```

> **Tip:** In Android Studio, right-click the `lib/screens/` folder in the Project panel → **New** → **Dart File** → type `create_entry_screen`.

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

> **Why dispose?** Controllers use system resources (like memory). The `dispose()` method is called when the screen is closed — it's the right place to clean up. If you skip this, the app will still work, but it's a bad habit that can cause issues in larger apps.
>
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

You should now see two input fields on the screen.

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

Try it — tapping the date button should open a calendar picker.

---

### Step 5: Add a Save button
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
Now we need to make the "+" button in `home_screen.dart` open the new screen and handle the result.

You'll need to import the `CreateEntryScreen` class. Since both files are in the same `screens/` folder, the import path is simple — type `CreateEntryScreen` in your code and press **Alt+Enter** to let Android Studio add the import for you.

Create a new method `_openCreateScreen()` in `_HomeScreenState` that:
1. Uses `Navigator.push` to open `CreateEntryScreen`
2. Waits (`await`) for the result — Navigator.push returns the value passed to `Navigator.pop`
3. If the result is not null, inserts the new entry at position 0 in `_entries` using `setState`

Here's the structure:
```dart
Future<void> _openCreateScreen() async {
  final newEntry = await Navigator.push<Entry>(
    context,
    MaterialPageRoute(builder: (_) => const CreateEntryScreen()),
  );
  if (newEntry != null) {
    setState(() => _entries.insert(0, newEntry));
  }
}
```

Then update the `FloatingActionButton`'s `onPressed` to call this method:
```dart
onPressed: _openCreateScreen,
```

> **Why a separate method?** Keeping navigation logic out of the `build` method makes code easier to read and maintain. The `build` method should focus on describing the UI, while methods like `_openCreateScreen` handle actions.

> **Reference:** [../examples/03_navigation/](../examples/03_navigation/) — see how Screen A opens Screen B and gets a value back

---

## Optional extensions
- Add a "Cancel" button in the AppBar that pops without saving
- Show a confirmation dialog if the user taps Cancel after typing something (see the cheatsheet's "Show a confirmation dialog" snippet)
- Format the date button using `DateFormat` from the `intl` package instead of the manual `day/month/year` format
- Add a character counter below the title field (hint: use `_titleController.addListener`)
- Sort the feed newest-first after every save (hint: `_entries.sort((a, b) => b.date.compareTo(a.date))`)
- Extract the date picker `onPressed` callback into a separate `_pickDate()` method (same pattern as `_save` — keeps the build method clean)
- Customize the `TextField` decoration: try adding `hintText`, a `prefixIcon` (e.g. `Icon(Icons.title)`), or changing the border style
- Add validation for the text field too — show a different message if the text body is empty (hint: don't block saving, just show a warning)
- Try replacing `TextButton` save button with `ElevatedButton` or `FilledButton` — which style do you prefer?

---

## Useful Flutter widgets/functions

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
