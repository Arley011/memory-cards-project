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
- [ ] The user can pick a date using the date picker
- [ ] Tapping "Save" returns to the feed
- [ ] The new entry is visible at the top of the feed immediately
- [ ] Basic validation: title cannot be empty
- [ ] You have customized at least **two** things about the form's appearance
- [ ] You can explain the difference between StatefulWidget and StatelessWidget

---

## Part 1: Understand the concepts first

Before writing any code, take 10 minutes to study two example files. These examples demonstrate everything you need for this stage.

### Step 1: Study the examples

**Open and read these files:**

1. **`examples/04_forms/form_demo.dart`** — Shows how to build a form with text fields and a date picker. Pay attention to:
   - `TextEditingController` — how does it connect to a `TextField`?
   - The `dispose()` method — why is it there?
   - `showDatePicker()` — what parameters does it need?
   - How the submit button reads text from the controllers

2. **`examples/03_navigation/screen_a.dart`** and **`screen_b.dart`** — Shows how one screen opens another and gets a value back. Pay attention to:
   - `Navigator.push` — what does `await` do here?
   - `Navigator.pop(context, value)` — how does Screen B send data back?
   - The `<String>` type in `Navigator.push<String>` — what does it mean?

> **Think about it:** In our app, the HomeScreen is like Screen A, and the CreateEntryScreen is like Screen B. Instead of passing a String back, we'll pass an `Entry` object. Can you see how the pattern would work?

---

## Part 2: Build the Create Entry screen

### Step 2: Create the file and set up the skeleton

Create a new file: `lib/screens/create_entry_screen.dart`

> **Tip:** In Android Studio, right-click the `lib/screens/` folder → **New** → **Dart File** → type `create_entry_screen`.

Start with this skeleton. It's a `StatefulWidget` with nothing in it yet — you'll fill it in step by step:

```dart
import 'package:flutter/material.dart';
import '../models/entry.dart';

class CreateEntryScreen extends StatefulWidget {
  const CreateEntryScreen({super.key});

  @override
  State<CreateEntryScreen> createState() => _CreateEntryScreenState();
}

class _CreateEntryScreenState extends State<CreateEntryScreen> {
  // TODO Step 3: Add TextEditingControllers for title and text
  // TODO Step 3: Add a dispose() method to clean them up

  // TODO Step 5: Add a DateTime variable for the selected date

  // TODO Step 6: Write the _save() method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Memory'),
        // TODO Step 6: Add a Save button in the actions
      ),
      body: const Center(child: Text('Form goes here')),
      // TODO Step 4: Replace body with the actual form
    );
  }
}
```

> **Why StatefulWidget?** The user will type text, pick a date — these are things that **change** while the screen is open. A `StatelessWidget` can't hold changing data. Study the comments in `examples/02_stateful_widget/counter_demo.dart` if you want to understand this deeper.

---

### Step 3: Add text controllers

You need two controllers: one for the title, one for the text body.

**Your task:** Look at how `_nameController` and `_noteController` are created and disposed in `examples/04_forms/form_demo.dart`. Do the same thing here:

1. Create two `TextEditingController` variables called `_titleController` and `_textController`
2. Add a `dispose()` method that disposes both controllers

> **Why dispose?** Controllers use system resources (like memory). The `dispose()` method is called when the screen closes — it's the right place to clean up. If you skip this, the app still works, but it's a bad habit. In the example, look at lines 46-49 to see the pattern.

---

### Step 4: Build the form layout

Now replace `body: const Center(child: Text('Form goes here')),` with an actual form.

**Your task:** Build a form with these requirements:
- A `Padding` widget around everything (16 pixels on all sides)
- Inside: a `Column` with the children listed below
- A `TextField` connected to `_titleController`, with label "Title" and an `OutlineInputBorder`
- A `SizedBox(height: 16)` for spacing
- A `TextField` connected to `_textController`, with label "What happened?", an `OutlineInputBorder`, and `maxLines: 5` (so it's taller)

**Hints:**
- Look at how `TextFormField` is used in `examples/04_forms/form_demo.dart` lines 94-112 — you can use `TextField` instead of `TextFormField` (simpler, no validation built in)
- A `TextField` needs a `controller` parameter and a `decoration` parameter
- `InputDecoration` takes `labelText` and `border`

**After you get it working, experiment:**
- Try adding `hintText: 'Give this memory a name'` inside the InputDecoration — how is it different from `labelText`?
- Try adding `prefixIcon: Icon(Icons.title)` — does it look good?
- Change the border: try `UnderlineInputBorder()` instead of `OutlineInputBorder()` — which do you prefer?
- Add `textCapitalization: TextCapitalization.sentences` to the text TextField — what does it do?
- Try `maxLines: 3` vs `maxLines: 8` on the text field — find a height you like

Pick the styling you like best and keep it.

---

### Step 5: Add a date picker

You need a date variable and a button that opens the date picker dialog.

**Your task:**
1. Add a `DateTime _selectedDate = DateTime.now();` variable next to your controllers
2. Add a date picker button below the text field in your Column (with a `SizedBox(height: 16)` before it)

**Study the `_pickDate()` method in `examples/04_forms/form_demo.dart` (lines 69-80).** It shows exactly how to use `showDatePicker`. You need to:
- Use `TextButton.icon` or `OutlinedButton.icon` as the button (your choice)
- Use `Icons.calendar_today` as the icon
- Call `showDatePicker` in the `onPressed` callback (remember: `async` and `await`)
- Pass `context`, `initialDate`, `firstDate`, and `lastDate` to showDatePicker
- If the user picks a date (`picked != null`), update `_selectedDate` using `setState`
- Show the selected date in the button's label text

> **Challenge:** Can you figure out how to format the date nicely using `DateFormat` from the `intl` package (like you did in Stage 1) instead of the basic `day/month/year` format?

> **Experiment:** What happens if you set `lastDate` to `DateTime(2030)` instead of `DateTime.now()`? Should users be able to create memories for future dates? There's no wrong answer — it's a design decision.

---

### Step 6: Add validation and the Save button

Two things left: a Save button that creates an `Entry` and returns it, and validation to prevent empty titles.

**Part A — The Save button:**

Add a `TextButton` to the AppBar's `actions` list. The AppBar already has a `title` — now add:
```dart
actions: [
  TextButton(
    onPressed: _save,
    child: const Text('Save'),
  ),
],
```

**Part B — The `_save()` method:**

Write a `_save()` method that does the following (in this order):
1. Read the title from `_titleController.text` and trim whitespace using `.trim()`
2. If the title is empty, show an error message and **return early** (don't save)
3. Create a new `Entry` object with the data from the form
4. Use `Navigator.pop(context, newEntry)` to close the screen and return the entry

**Hints:**
- To show an error: `ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('...')))` — see the example at line 57
- To create an Entry, look at the constructor in `lib/models/entry.dart` — you need `id`, `title`, `text`, and `date`
- For the `id`, use `DateTime.now().millisecondsSinceEpoch.toString()` — this creates a unique ID based on the current time
- `Navigator.pop(context, newEntry)` is the key line — it's how you send the entry back to HomeScreen

> **Think about it:** What happens if `Navigator.pop` is called without the second argument? What would HomeScreen receive? (Hint: look at the navigation example — what happens when the user presses the system back button?)

**After it works, experiment:**
- Try different button styles: replace `TextButton` with `ElevatedButton` or `FilledButton` — which looks best in the AppBar?
- Try adding a "Cancel" button on the left side of the AppBar (hint: use `leading` parameter instead of `actions`)
- What happens if you tap Save with an empty title? Is the error message clear?

---

## Part 3: Connect the screens

### Step 7: Make the "+" button open your new screen

Open `lib/screens/home_screen.dart`. The `FloatingActionButton` currently has an empty `onPressed`. You need to make it open `CreateEntryScreen` and handle the result.

**Your task:** Study `_goToScreenB()` in `examples/03_navigation/screen_a.dart` (lines 17-31). It shows the exact pattern you need. Adapt it for our app:

1. Create a method `_openCreateScreen()` in `_HomeScreenState`
2. It should be `async` and return `Future<void>`
3. Use `Navigator.push<Entry>(...)` to open `CreateEntryScreen` (instead of `<String>` and `ScreenB`)
4. `await` the result — it will be the Entry that `_save()` passes to `Navigator.pop`
5. If the result is not null, add the entry to the beginning of `_entries` using `setState` and `.insert(0, newEntry)`
6. Update the FAB's `onPressed` to call `_openCreateScreen`

**Don't forget:** You need to import `CreateEntryScreen`. Type `CreateEntryScreen` in your code and press **Alt+Enter** to let Android Studio add the import automatically.

**Test it:**
- Tap "+", fill in the fields, tap "Save" — does the new entry appear?
- Tap "+", then press the back button without saving — does anything break?
- Create 3 entries — are they in the right order (newest at top)?

---

## Part 4: Polish and explore

### Step 8: Improve the user experience

Now that the basic flow works, try improving it. Pick at least **two** of these:

1. **Better validation message.** Right now the SnackBar probably shows a plain message. Try adding `backgroundColor: Colors.red.shade400` to the SnackBar to make errors more noticeable.

2. **Confirmation on discard.** If the user typed something and taps Back, they lose their work. Can you show a confirmation dialog? Look at the cheatsheet's "Show a confirmation dialog" section for the `showDialog` + `AlertDialog` pattern.

3. **Character counter.** Add a counter below the title field that shows how many characters are typed. Hint: use `_titleController.addListener(...)` in `initState()` — see `examples/02_stateful_widget/counter_demo.dart` lines 59-66 for the pattern.

4. **Sort the feed.** After adding a new entry, sort `_entries` so the newest date is always first: `_entries.sort((a, b) => b.date.compareTo(a.date))` — put this inside your `setState`.

5. **Format the date button.** Use `DateFormat` (from `intl` package) to format the date on the picker button more nicely — something like `'EEE, d MMM yyyy'`.

---

## Optional extensions (for fast learners)

- Add a text field for "location" (where did this memory happen?) — you'll need another controller, another TextField, and to pass the value somehow (hint: you could just prepend it to the text for now)
- Try wrapping the form in a `ListView` instead of a `Column` — what happens when the keyboard opens? Which behaves better?
- Add a `TextButton` in the empty state (from Step 8 of Stage 1) that also opens the create screen — reuse `_openCreateScreen`
- Research `PopScope` widget — it lets you intercept the back button. Can you show a "Discard changes?" dialog when the user presses back after typing?
- Try adding `autofocus: true` to the title TextField — the keyboard opens automatically. Is this a good UX choice? Why or why not?

---

## Useful Flutter widgets/concepts

| Widget / concept | What it does |
|---|---|
| `StatefulWidget` | A widget that can change — holds mutable state |
| `setState(() { ... })` | Tells Flutter to rebuild the widget with new state |
| `TextEditingController` | Reads what the user typed in a `TextField` |
| `dispose()` | Called when the widget is removed — clean up controllers here |
| `TextField` | A text input field |
| `InputDecoration` | Adds label, border, hint, icon to a `TextField` |
| `showDatePicker(...)` | Opens the system date picker dialog |
| `Navigator.push(context, route)` | Opens a new screen |
| `Navigator.pop(context, value)` | Closes the screen and optionally returns a value |
| `MaterialPageRoute` | Defines the transition animation to a new screen |
| `await` / `async` | Wait for an async result (screen closing, date picker, etc.) |
| `ScaffoldMessenger.showSnackBar(...)` | Shows a brief message at the bottom |
| `.trim()` | Removes whitespace from the start and end of a string |
| `.insert(0, item)` | Adds an item at the beginning of a list |
