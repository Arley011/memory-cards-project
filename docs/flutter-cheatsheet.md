# Flutter Cheat Sheet

Quick reference for everything used in this course. Code blocks are minimal — expand them as needed.

---

## The Widget Tree

Every Flutter UI is a tree of nested widgets. The root is `MaterialApp`, which contains a `Scaffold`, which contains your actual content.

```
MaterialApp
└── Scaffold
    ├── appBar: AppBar(title: Text('My App'))
    ├── body: Column(children: [...])
    └── floatingActionButton: FloatingActionButton(...)
```

Widgets are immutable — to change what's shown, you call `setState()` which rebuilds the tree.

---

## Layout Widgets

### Column — stack children vertically
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,   // vertical alignment
  crossAxisAlignment: CrossAxisAlignment.start,  // horizontal alignment
  children: [Text('A'), Text('B'), Text('C')],
)
```

### Row — place children horizontally
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [Text('Left'), Text('Right')],
)
```

### Padding — add space around a widget
```dart
Padding(
  padding: const EdgeInsets.all(16),          // all sides
  // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  // padding: const EdgeInsets.only(top: 8, bottom: 8),
  child: Text('padded text'),
)
```

### SizedBox — fixed gap or sized container
```dart
const SizedBox(height: 16)   // vertical gap
const SizedBox(width: 8)     // horizontal gap
SizedBox(height: 100, width: double.infinity, child: ...)  // fixed-size box
```

### Card — elevated container with rounded corners
```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Text('Card content'),
  ),
)
```

### Expanded / Flexible — fill remaining space
```dart
Row(
  children: [
    Expanded(child: TextField(...)),  // takes all remaining space
    const SizedBox(width: 8),
    ElevatedButton(onPressed: ..., child: Text('Send')),
  ],
)
```

### Wrap — like Row but wraps to next line
```dart
Wrap(
  spacing: 8,     // horizontal gap between items
  runSpacing: 8,  // vertical gap between rows
  children: ['A', 'B', 'C'].map((t) => Chip(label: Text(t))).toList(),
)
```

---

## List Widgets

### ListView.builder — efficient scrollable list
```dart
ListView.builder(
  itemCount: _entries.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(_entries[index].title));
  },
)
```
Use `ListView.builder` for dynamic or long lists. Use `ListView(children: [...])` only for short static lists.

### ListTile — pre-built row widget
```dart
ListTile(
  leading: Icon(Icons.star),
  title: Text('Title'),
  subtitle: Text('Subtitle'),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () {},
)
```

---

## StatefulWidget

```dart
class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  // State variables live here
  int _count = 0;

  @override
  void initState() {
    super.initState();
    // Called ONCE when the widget is first created
    // Use for: loading data, setting up controllers/listeners
  }

  @override
  void dispose() {
    // Called when the widget is removed
    // Use for: disposing controllers, cancelling timers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('$_count'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _count++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**`setState(() { ... })`** — always wrap changes to state variables inside `setState`. Without it, Flutter won't know to rebuild the widget.

---

## Navigation

### Go to a new screen
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const OtherScreen()),
);
```

### Go back
```dart
Navigator.pop(context);
```

### Go to a new screen and get a result back
```dart
// Screen A: open and wait for result
final result = await Navigator.push<String>(
  context,
  MaterialPageRoute(builder: (_) => const ScreenB()),
);
// result is the value returned by Screen B (or null if back button was pressed)

// Screen B: return a value to Screen A
Navigator.pop(context, 'hello from B');
```

---

## Forms

### TextEditingController
```dart
// In the State class:
final _controller = TextEditingController();

@override
void initState() {
  super.initState();
  // optional: _controller.addListener(() { ... });
}

@override
void dispose() {
  _controller.dispose(); // ALWAYS dispose
  super.dispose();
}

// In build():
TextField(
  controller: _controller,
  decoration: const InputDecoration(
    labelText: 'Title',
    border: OutlineInputBorder(),
  ),
)

// Read the value:
final text = _controller.text.trim();
```

### Form with validation
```dart
final _formKey = GlobalKey<FormState>();

// Wrap your fields:
Form(
  key: _formKey,
  child: Column(children: [
    TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        return null; // valid
      },
    ),
  ]),
)

// Validate on save:
if (_formKey.currentState!.validate()) {
  // all validators returned null → proceed
}
```

### Date picker
```dart
final picked = await showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2020),
  lastDate: DateTime.now(),
);
if (picked != null) {
  setState(() => _selectedDate = picked);
}
```

### Time picker
```dart
final picked = await showTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
);
if (picked != null) {
  setState(() => _selectedTime = picked);
}
```

---

## Date formatting with `intl`

```dart
import 'package:intl/intl.dart';

DateFormat('dd MMM yyyy').format(date)  // "01 Sep 2025"
DateFormat('d/M/y').format(date)        // "1/9/2025"
DateFormat('EEEE').format(date)         // "Monday"
DateFormat('MMM d').format(date)        // "Sep 1"
```

---

## Useful Snippets

### Show a snackbar message
```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Saved!')),
);
```

### Show a confirmation dialog
```dart
final confirmed = await showDialog<bool>(
  context: context,
  builder: (ctx) => AlertDialog(
    title: const Text('Are you sure?'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm')),
    ],
  ),
);
if (confirmed == true) { /* proceed */ }
```

### Conditional widget rendering
```dart
// In a children list:
if (entry.tags.isNotEmpty) ...[
  const SizedBox(height: 8),
  Wrap(children: entry.tags.map((t) => Chip(label: Text(t))).toList()),
],

// Ternary:
entry.imagePath != null
  ? Image.file(File(entry.imagePath!))
  : const Icon(Icons.image_not_supported),
```

### Map a list to widgets
```dart
// List<String> → List<Widget>
tags.map((tag) => Chip(label: Text(tag))).toList()

// With index:
List.generate(items.length, (i) => Text(items[i]))
```

---

## Common Icons

```dart
Icons.add                // +
Icons.arrow_back         // ←
Icons.arrow_forward_ios  // › (right chevron)
Icons.delete_outline     // trash
Icons.edit               // pencil
Icons.search             // magnifying glass
Icons.calendar_today     // calendar
Icons.label_outline      // tag
Icons.photo_library      // gallery
Icons.camera_alt         // camera
Icons.settings           // gear
Icons.auto_stories_outlined  // open book
Icons.favorite           // heart
Icons.star               // star
```

Browse all icons: search `Icons.` in VS Code and press `Ctrl+Space` for autocomplete.
