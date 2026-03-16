# Stage 5 — Track B: Search & Discovery

## Goal
Add a search bar to the home screen so users can filter entries by title or text.

## What the app will look like at the end
A search field appears at the top of the feed. As the user types, the list updates in real time to show only entries whose title or text contains the search term. When no entries match, a friendly "no results" message appears.

## Minimum required outcome (checkpoint)
- [ ] A search field is visible on the home screen
- [ ] Typing filters the entry list in real time
- [ ] Clearing the search restores the full list
- [ ] A "no results" message appears when nothing matches

---

## Step-by-step guide

### Step 1: Add search state
In `_HomeScreenState`, add a variable for the current search query:
```dart
String _searchQuery = '';
```

---

### Step 2: Add a computed filtered list
Add a getter that returns entries matching the current query. Add this inside `_HomeScreenState`, before the `build` method:
```dart
List<Entry> get _filteredEntries {
  if (_searchQuery.isEmpty) return _entries;
  final query = _searchQuery.toLowerCase();
  return _entries.where((entry) {
    return entry.title.toLowerCase().contains(query)
        || entry.text.toLowerCase().contains(query);
  }).toList();
}
```

> **Hint:** A getter looks like a method but is used like a variable: `_filteredEntries.length`.

---

### Step 3: Add the search field to the UI
You need to restructure the `body` of your Scaffold. Wrap everything in a `Column`: the search field at the top, and the feed below it wrapped in `Expanded` (so it fills the remaining space).

Here's the search field — this is a new widget (`TextField` with `onChanged`), so use this code directly:
```dart
Padding(
  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
  child: TextField(
    decoration: const InputDecoration(
      hintText: 'Search memories...',
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(),
    ),
    onChanged: (value) {
      setState(() => _searchQuery = value);
    },
  ),
),
```

Now build the rest yourself using these hints:

> **Hint 1:** Your `body` should be a `Column` with two children: the `Padding` containing the `TextField` above, and an `Expanded` widget wrapping the feed.

> **Hint 2:** Extract the feed building logic into a `_buildFeed()` method that uses `_filteredEntries` instead of `_entries`.

> **Hint 3:** In `_buildFeed()`, handle two empty states differently: if `_searchQuery.isEmpty` and the list is empty, show the normal "No memories yet" state. If `_searchQuery` is not empty and `_filteredEntries` is empty, show a "No results" message with `Icons.search_off`.

> **Important:** When deleting from a filtered list, be careful — `index` in `_filteredEntries` is not the same as in `_entries`. Use `_entries.indexOf(entries[index])` to find the correct position in the original list. Otherwise, deleting while searching would remove the wrong entry!

---

### Step 4: Verify it works
- Type "Gut Wehlitz" → only the arrival entry shows
- Type a word from an entry's text → the entry still shows
- Clear the search → all entries come back
- Search for something that doesn't exist → "no results" message appears

---

## Optional extensions
- Add a clear button (×) on the right side of the search field (hint: use `suffixIcon` with an `IconButton` + a `TextEditingController`)
- Add search history — save the last 5 search terms using SharedPreferences and show them as suggestions
- Search by tags too, not just title and text (hint: check if any tag in `entry.tags` contains the query)
- Highlight the matched text in the results (hint: wrap the matching substring in a `TextSpan` with a yellow background)
- Add sort options: newest first / oldest first / alphabetical (hint: show a bottom sheet with `showModalBottomSheet`)

---

## Useful Flutter widgets/functions

| Widget / concept | What it does |
|---|---|
| `TextField` with `onChanged` | Calls a function every time the user types |
| `getter` (`List<Entry> get name { ... }`) | Computes a value on demand, like a method but used as a variable |
| `list.where((item) => condition).toList()` | Filters a list |
| `string.toLowerCase().contains(query)` | Case-insensitive text search |
| `Column` + `Expanded` | Layout trick to make a scrollable list fill remaining space |
| `InputDecoration` | Adds hint, icon, border to a TextField |
| `Icons.search` / `Icons.search_off` | Search-related icons |
