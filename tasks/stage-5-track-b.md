# Stage 5 — Track B: Search & Discovery

## Today's goal
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
This step requires restructuring the `body` of your `Scaffold`. Replace the **entire** `body:` value (both the empty state and the ListView) with a new structure that has the search field at the top:

```dart
body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search memories...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    ),
    Expanded(
      child: _buildFeed(),
    ),
  ],
),
```

Now extract the feed into a separate method. Add this inside `_HomeScreenState`:
```dart
Widget _buildFeed() {
  final entries = _filteredEntries;
  if (entries.isEmpty) {
    // Show different messages for "no entries" vs "no search results"
    if (_searchQuery.isEmpty) {
      return const Center(child: Text('No memories yet. Tap + to create one!'));
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('No results for "$_searchQuery"',
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
  return ListView.builder(
    itemCount: entries.length,
    itemBuilder: (context, index) {
      return EntryCard(
        entry: entries[index],
        onDelete: () => _deleteEntry(_entries.indexOf(entries[index])),
      );
    },
  );
}
```

> **Important:** Notice `_entries.indexOf(entries[index])` in the delete callback — we need the index in the **original** list, not the filtered list. Otherwise, deleting while searching would remove the wrong entry!

---

### Step 4: Verify it works
- Type "Gut Wehlitz" → only the arrival entry shows
- Type a word from an entry's text → the entry still shows
- Clear the search → all entries come back
- Search for something that doesn't exist → "no results" message appears

---

## Optional extensions
- Add a clear button (×) on the right of the search field (hint: add a `TextEditingController` and use `suffixIcon` with an `IconButton` that clears it)
- Highlight the matched text in the results (hint: wrap the matching substring in a `TextSpan` with a yellow background)
- Combine search with tag filters — show chips for each tag above the list, filter by both simultaneously
- Add sort options: newest first / oldest first / alphabetical (hint: show a bottom sheet with `showModalBottomSheet`)

---

## Useful Flutter widgets/functions today

| Widget / concept | What it does |
|---|---|
| `TextField` with `onChanged` | Calls a function every time the user types |
| `getter` (`List<Entry> get name { ... }`) | Computes a value on demand, like a method but used as a variable |
| `list.where((item) => condition).toList()` | Filters a list |
| `string.toLowerCase().contains(query)` | Case-insensitive text search |
| `Column` + `Expanded` | Layout trick to make a scrollable list fill remaining space |
| `InputDecoration` | Adds hint, icon, border to a TextField |
| `Icons.search` / `Icons.search_off` | Search-related icons |
