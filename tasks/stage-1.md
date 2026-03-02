# Stage 1 — First Screen + UI Basics

## Today's goal
Display a scrollable feed of memory cards using hardcoded sample data.

## What the app will look like at the end
The main screen shows a list of cards, each with a title, date, and preview text. The layout is clean and visually consistent. Scrolling through the list works smoothly. The "+" button is visible but doesn't do anything yet.

## Minimum required outcome (checkpoint)
- [ ] The app runs without errors
- [ ] At least 3 sample entries are visible as cards in the feed
- [ ] Each card shows: title, date, and text preview
- [ ] The list is scrollable
- [ ] You have made at least one visual change to the card styling (color, spacing, or layout)

---

## Step-by-step guide

### Step 1: Show the sample data
Open `lib/screens/home_screen.dart`.

Find the line:
```dart
final List<Entry> _entries = [];
```

The list is empty — that's why you see the empty state. Change it to use the sample entries:
1. Uncomment the import at the top: `import '../data/sample_entries.dart';`
2. Change the empty list to use sample data:

```dart
// Before:
final List<Entry> _entries = [];

// After:
final List<Entry> _entries = List.from(sampleEntries);
```

Save the file (Cmd+S / Ctrl+S) — the app should update automatically. If it doesn't, press `r` in the terminal where `flutter run` is running. You should now see 7 cards!

> **Hint:** `List.from(...)` creates a copy of the list so we can safely add/remove items later.

---

### Step 2: Explore the card layout
Open `lib/widgets/entry_card.dart`. This widget draws one card.

Try these changes (one at a time — use hot reload after each!):
- Change the title color: inside the `.copyWith(...)` for the title, add `color: Colors.deepPurple` next to `fontWeight: FontWeight.bold`
- Change the `elevation` on the `Card` to `6` — what happens to the shadow?
- Change `maxLines: 3` to `maxLines: 2` — what changes?
- Add `const SizedBox(height: 12)` before the text preview `Text` widget (the one that shows `entry.text`) — does the spacing change?

> **Hint:** After each change, save the file (Cmd+S / Ctrl+S). Hot reload happens automatically.

---

### Step 3: Improve the date formatting
The date currently shows as `dd MMM yyyy` (e.g. "01 Sep 2025").

Find this line in `entry_card.dart`:
```dart
DateFormat('dd MMM yyyy').format(entry.date)
```

Try a different format — change the pattern inside the quotes:
- `'EEEE, d MMMM yyyy'` → "Monday, 1 September 2025"
- `'d/M/y'` → "1/9/2025"
- `'MMM d'` → "Sep 1"

Pick the format you like most.

> **Reference:** [docs/flutter-cheatsheet.md](../docs/flutter-cheatsheet.md) — "Date formatting with intl"

---

### Step 4: Style the card header
Inside `entry_card.dart`, the title and date are stacked vertically (title on top, date below). Let's put them on the same line with the date pushed to the right.

First, create a variable to hold the formatted date. Add this line **inside** the `build` method, **before** the `return` statement:
```dart
final dateString = DateFormat('dd MMM yyyy').format(entry.date);
```

Then replace the title, SizedBox, and date block with a single `Row`:

```dart
// Replace this:
            // Title
            Text(
              entry.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            // Date — formatted with intl package
            Text(
              DateFormat('dd MMM yyyy').format(entry.date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),

// With this:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  dateString,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
```

Save and check — the title and date should now be side by side.

> **Hint:** If you see a red error screen, check that you removed the old `Text` widgets and the `SizedBox` between them. The `Row` replaces all three.

---

### Step 5: Improve the empty state (optional)
When `_entries` is empty, the app shows a placeholder message. Find it in `home_screen.dart`.

Improve it:
- Change the icon to something more expressive (browse `Icons.` in VS Code for suggestions)
- Change the message text to something friendlier
- Add a subtitle line below the main message

---

## VS Code tips

These shortcuts will save you a lot of time:

| Shortcut | What it does |
|---|---|
| **Cmd+S** (Ctrl+S) | Save the file — triggers hot reload automatically |
| **Cmd+.** (Ctrl+.) | Quick Actions menu on the selected widget — wrap with Row/Column/Padding, extract to new widget, remove a widget, and more |
| **Alt+Space** (Ctrl+Space) | Inside a widget's parentheses, shows all available parameters with descriptions |
| **Cmd+Click** (Ctrl+Click) | Click on any widget or class name to jump to its source code / documentation |

> Try it now: click on `Card` in `entry_card.dart`, then press **Cmd+Click** — you'll see all the parameters `Card` accepts!

---

## Optional extensions
- Extract the empty-state placeholder (the `Column` with icon + texts in `home_screen.dart`) into its own widget file `lib/widgets/empty_feed.dart` — practice creating a new file and importing it
- Add an 8th sample entry to `sample_entries.dart` about your own Erasmus experience
- Change the app's theme color in `main.dart` — find `Color(0xFF6750A4)` and try other hex colors (search "hex color picker" online)
- Add a thin color bar on the left edge of each card using a `Container` with `width: 4` and a `color`
- Try different `Card` shapes: change `elevation`, add `shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))`

---

## Useful Flutter widgets/functions today

| Widget / concept | What it does |
|---|---|
| `ListView.builder` | Builds a list efficiently — one item at a time |
| `Card` | Rounded container with a drop shadow |
| `Column` | Stacks children vertically |
| `Row` | Places children horizontally |
| `Padding` | Adds space around a widget |
| `SizedBox(height: x)` | Adds a fixed vertical gap |
| `Text` + `TextStyle` | Shows text with custom font, size, color |
| `DateFormat('pattern').format(date)` | Formats a DateTime as a String |
| `maxLines` + `overflow: TextOverflow.ellipsis` | Truncates long text with "..." |
| `Icons.some_name` | Material icon — browse with Ctrl+Space in VS Code |
