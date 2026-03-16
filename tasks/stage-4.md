# Stage 4 — Tags + Better Usability

> **Before you start:** Make sure Stage 3 is working — entries persist after restarting the app, and you can delete entries by swiping.

## Goal
Add category tags to entries, display them as colored chips on each card, and clean up the overall visual quality of the app.

## What the app will look like at the end
When creating an entry, the user can select one or more tags (Travel, Food, Erasmus, Ideas, Culture, Other). Each card in the feed shows the selected tags as small colored labels below the text. The app looks polished and consistent.

## Minimum required outcome (checkpoint)
- [ ] The Create Entry screen shows a list of selectable tags
- [ ] Selected tags are saved with the entry
- [ ] Tags appear as chips/labels on the entry card
- [ ] The overall spacing and typography is consistent throughout the app

### How tags flow through the app

```
CreateEntryScreen            Entry model             EntryCard
┌─────────────────┐      ┌──────────────────┐     ┌─────────────────┐
│  FilterChip     │      │                  │     │                 │
│  taps toggle    │ ──→  │  tags: ['Travel', │ ──→ │  Chip widgets   │
│  _selectedTags  │      │         'Food']  │     │  with colors    │
└─────────────────┘      └──────────────────┘     └─────────────────┘
```

---

## Step-by-step guide

### Step 1: Use the available tags list
The list of tags is already defined in `lib/data/sample_entries.dart`:
```dart
const List<String> availableTags = [
  'Travel', 'Food', 'Erasmus', 'Ideas', 'Culture', 'Other',
];
```

You'll need access to the `availableTags` list from `sample_entries.dart`. Type `availableTags` in your code and press **Alt+Enter** to let Android Studio add the import.

---

### Step 2: Add tag selection state
In `_CreateEntryScreenState`, add a set to track which tags are selected:
```dart
final Set<String> _selectedTags = {};
```

We use a `Set` instead of a `List` because a Set automatically prevents duplicates.

---

### Step 3: Show tag chips in the form
Add this inside the `children` list in your form's `Column`, below the date picker button:

Start with a `SizedBox(height: 16)`, a bold `Text('Tags')` label, and another `SizedBox(height: 8)` for spacing.

Then add a `Wrap` widget. `Wrap` is like `Row`, but it wraps to the next line when the chips don't fit. Inside `Wrap`, use `availableTags.map((tag) { ... }).toList()` to create a `FilterChip` for each tag.

> **What does `.map().toList()` do?** `.map((item) { return Widget(...); })` transforms each item in a list into something else (here, into a widget). `.toList()` converts the result back into a regular List, which Flutter needs.

Here are the key `FilterChip` properties you need to set:
- `label: Text(tag)` — the text shown on the chip
- `selected: _selectedTags.contains(tag)` — whether this chip is highlighted
- `onSelected: (selected) { ... }` — callback when tapped

> **Hint:** Inside `onSelected`, use `setState` to either `_selectedTags.add(tag)` or `_selectedTags.remove(tag)` based on the `selected` parameter.

Here is the structure to guide you:

```dart
Wrap(
  spacing: 8,
  children: availableTags.map((tag) {
    return FilterChip(
      // set label, selected, and onSelected here
    );
  }).toList(),
),
```

`FilterChip` is a chip that can be toggled on/off — perfect for multi-select.

---

### Step 4: Pass tags to the Entry
Update the `_save()` method to include the selected tags:

```dart
final newEntry = Entry(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  title: title,
  text: _textController.text.trim(),
  date: _selectedDate,
  tags: _selectedTags.toList(), // Convert Set to List
);
```

---

### Step 5: Display tags on the card
Open `lib/widgets/entry_card.dart`. The goal is to show the selected tags as small colored chips below the text preview on each card.

Replace the `// TODO Stage 4` comment with code that conditionally shows the tags.

In Dart, `if (condition) ...[widget1, widget2]` lets you conditionally add multiple widgets to a list. The `...` (spread operator) unpacks the inner list into the outer one.

Here is what you need to do:
- Use `if (entry.tags.isNotEmpty) ...[...]` to only show tags when they exist
- Inside, add a `SizedBox(height: 8)` for spacing, then a `Wrap` widget with `spacing: 4` and `runSpacing: 4`
- Map each tag to a `Chip` widget (similar to how you used `.map().toList()` in Step 3)
- Use `backgroundColor: _tagColor(tag).withOpacity(0.2)` and `side: BorderSide(color: _tagColor(tag))` on the `Chip` for a subtle colored look

Create a `_tagColor(String tag)` helper method inside the `EntryCard` class (before the `build` method) that returns a `Color` based on the tag name. Use a `Map` to associate each tag with a color:

```dart
Color _tagColor(String tag) {
  const colors = {
    'Travel': Colors.blue,
    'Food': Colors.orange,
    'Erasmus': Colors.purple,
    'Ideas': Colors.green,
    'Culture': Colors.red,
    'Other': Colors.grey,
  };
  return colors[tag] ?? Colors.grey;
}
```

---

> **Note:** Entries you created before Stage 4 won't show any tags — that's normal. Only new entries will have tags.

---

### Step 6: Polish pass
Go through the app and improve visual consistency:
- Make sure all screens use the same padding value (e.g. 16 everywhere)
- Check that the empty state on the home screen looks good
- Verify that the AppBar title style is consistent
- Check that buttons have clear labels (not just icons)

---

## Optional extensions
- Add filter chips on the home screen to show only entries with a specific tag
- Show a "no results" empty state when the filter returns nothing
- Add tag colors that are visible in both light and dark mode
- Show a count of selected tags next to the "Tags" label (e.g. "Tags (2 selected)")
- Try using `ChoiceChip` instead of `FilterChip` on the create screen — what's the difference? When would you use each?
- **Custom tag creation (big challenge):** Let the user create their own tags on-the-fly in the Create Entry screen. This requires:
  - Storing the custom tags list persistently (another SharedPreferences key, or extend the storage helper)
  - A `TextField` + "Add" button next to the chip list for entering a new tag name
  - Validation: tag name cannot be empty, max length ~20 characters, no duplicate names
  - Color selection for the new tag: use a predefined palette of ~10 colors to choose from, or explore a color picker package
  - Update the `_tagColor` helper to handle custom tags too

---

## Useful Flutter widgets/functions

| Widget / concept | What it does |
|---|---|
| `FilterChip` | A chip that toggles on/off when tapped |
| `Chip` | A read-only label chip |
| `Wrap` | Like Row but wraps to next line when out of space |
| `Set<T>` | A collection with no duplicates |
| `set.add(item)` / `set.remove(item)` | Add or remove from a Set |
| `set.contains(item)` | Check if item is in the Set |
| `set.toList()` | Convert Set to List |
| `color.withOpacity(0.2)` | Make a color semi-transparent |
| `...` (spread operator) | Insert multiple items into a list |
| `if (condition) ...[ widgets ]` | Conditionally include widgets in a list |
