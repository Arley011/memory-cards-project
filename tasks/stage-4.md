# Stage 4 — Tags + Better Usability

> **Before you start:** Make sure Stage 3 is working — entries persist after restarting the app, and you can delete entries with a long-press.

## Today's goal
Add category tags to entries, display them as colored chips on each card, and clean up the overall visual quality of the app.

## What the app will look like at the end
When creating an entry, the user can select one or more tags (Travel, Food, Erasmus, Ideas, Culture, Other). Each card in the feed shows the selected tags as small colored labels below the text. The app looks polished and consistent.

## Minimum required outcome (checkpoint)
- [ ] The Create Entry screen shows a list of selectable tags
- [ ] Selected tags are saved with the entry
- [ ] Tags appear as chips/labels on the entry card
- [ ] The overall spacing and typography is consistent throughout the app

---

## Step-by-step guide

### Step 1: Use the available tags list
The list of tags is already defined in `lib/data/sample_entries.dart`:
```dart
const List<String> availableTags = [
  'Travel', 'Food', 'Erasmus', 'Ideas', 'Culture', 'Other',
];
```

Import it in `create_entry_screen.dart` (if you don't already have this import):
```dart
import '../data/sample_entries.dart';
```

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

```dart
const SizedBox(height: 16),
const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
Wrap(
  spacing: 8,
  children: availableTags.map((tag) {
    final isSelected = _selectedTags.contains(tag);
    return FilterChip(
      label: Text(tag),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedTags.add(tag);
          } else {
            _selectedTags.remove(tag);
          }
        });
      },
    );
  }).toList(),
),
```

`FilterChip` is a chip that can be toggled on/off — perfect for multi-select.

> **Hint:** `Wrap` is like `Row`, but it wraps to the next line when the chips don't fit.

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
Open `lib/widgets/entry_card.dart` and replace the `// TODO Stage 4` comment with:

```dart
if (entry.tags.isNotEmpty) ...[
  const SizedBox(height: 8),
  Wrap(
    spacing: 4,
    runSpacing: 4,
    children: entry.tags.map((tag) {
      return Chip(
        label: Text(tag, style: const TextStyle(fontSize: 12)),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: _tagColor(tag).withOpacity(0.2),
        side: BorderSide(color: _tagColor(tag), width: 1),
      );
    }).toList(),
  ),
],
```

Add this helper method inside the `EntryCard` class, before the `build` method:
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
- Let the user create a custom tag by typing a name (hint: add a `TextField` + button next to the chips)
- Add tag colors that are visible in both light and dark mode
- Show a count of selected tags next to the "Tags" label (e.g. "Tags (2 selected)")

---

## Useful Flutter widgets/functions today

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
