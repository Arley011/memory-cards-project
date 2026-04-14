# Stage 1 — First Screen + UI Basics

## Goal
Display a scrollable feed of memory cards using hardcoded sample data, and understand how Flutter builds UI by experimenting with widgets.

## What the app will look like at the end
The main screen shows a list of cards, each with a title, date, and preview text. The layout is clean and visually consistent. Scrolling through the list works smoothly. The "+" button is visible but doesn't do anything yet.

## Minimum required outcome (checkpoint)
- [ ] The app runs without errors
- [ ] At least 3 sample entries are visible as cards in the feed
- [ ] Each card shows: title, date, and text preview
- [ ] The title and date are on the same line (Row layout)
- [ ] The list is scrollable
- [ ] You have made at least **three** visual changes to the card styling
- [ ] You can explain what `Column`, `Row`, `Padding`, and `SizedBox` do

---

## Part 1: Get the app running + understand the code

### Step 1: Run the app and explore the empty state
Open the project in Android Studio and run the app (`flutter run` or the green play button).

You should see an empty screen with an icon, a message, and a "+" button. This is the **empty state** — it appears when there are no entries in the list.

Before changing anything, look at the code:
1. Open `lib/screens/home_screen.dart`
2. Find the line `final List<Entry> _entries = [];` — this is an empty list. That's why you see the empty state.
3. Now find the `? :` pattern in the `body:` — this is called a **ternary operator**. It says: "if entries is empty, show the placeholder; otherwise, show the list."

> **Think about it:** What would happen if you added one item to `_entries`? Where would you expect the placeholder to disappear?

---

### Step 2: Load the sample data
Let's fill the list with sample entries so we have something to look at.

1. Uncomment the import at the top of `home_screen.dart`: `import '../data/sample_entries.dart';`
2. Change the empty list to use sample data:

```dart
final List<Entry> _entries = List.from(sampleEntries);
```

The app should hot reload and show 7 cards.

> **Why `List.from(...)`?** It creates a **copy** of the list. If we used `sampleEntries` directly, any changes (like adding or deleting entries later) would modify the original data. Open `lib/data/sample_entries.dart` to see what the sample data looks like — read a few entries. These are stories from a fictional Erasmus trip.

---

### Step 3: Read the code before changing it
Open `lib/widgets/entry_card.dart`. This file draws **one card** in the list.

Take a minute to read through it. Try to answer these questions by reading the code (don't change anything yet):

1. What widget wraps everything? (Hint: it gives the card its shadow and rounded corners)
2. How much padding does the card have inside? (Look for `EdgeInsets`)
3. What `Column` property makes the text align to the left instead of center?
4. How is the date formatted? What does `'dd MMM yyyy'` produce?
5. What does `maxLines: 3` do to the text preview?

> **Android Studio tip:** Hold **Cmd** (Mac) or **Ctrl** (Windows) and click on any widget name (like `Card` or `Column`) to jump to its Flutter documentation. This is the fastest way to learn what a widget can do.

---

## Part 2: Experiment with widgets

Now that you understand the structure, it's time to play. The goal here is to **try things, see what happens, and develop intuition** for how Flutter widgets work.

### Step 4: Widget experiments on the card

Open `lib/widgets/entry_card.dart`. Do these experiments **one at a time** — after each change, the app will hot reload so you can see the result immediately.

**Experiment A — Card appearance:**
The `Card` widget has several properties you can change. Try each of these separately:
- Add `elevation: 0` to the Card — what happens to the shadow?
- Change it to `elevation: 8` — what's different?
- Add `color: Colors.blue.shade50` to the Card — what changes?
- Add a `shape` parameter: `shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))` — how does the card look now?
- Try `borderRadius: BorderRadius.circular(0)` — and then `BorderRadius.circular(30)` — what's the difference?

Pick the combination you like best and keep it.

**Experiment B — Text styling:**
Find the title `Text` widget. It uses `Theme.of(context).textTheme.titleMedium?.copyWith(...)` for styling.
- Add `color: Colors.deepPurple` inside the `.copyWith(...)` — does the title color change?
- Try `fontSize: 20` — what happens?
- Try `letterSpacing: 1.5` — do you see the difference?
- Now change the date's color: find the date `Text` and try `color: Colors.deepPurple.shade300` instead of `Colors.grey`

**Experiment C — Spacing:**
- Change `const SizedBox(height: 4)` (between title and date) to `height: 0` — what happens?
- Now try `height: 16` — is there too much space?
- Change the Padding from `EdgeInsets.all(16)` to `EdgeInsets.all(8)` — the card feels more compact. Now try `EdgeInsets.all(24)` — it feels more spacious. Pick what you like.
- Try `EdgeInsets.symmetric(horizontal: 20, vertical: 12)` — what's the difference between `all` and `symmetric`?

**Experiment D — Text preview:**
Find `maxLines: 3` on the text preview:
- Change it to `maxLines: 1` — the text is cut short. Why might you want this?
- Change it to `maxLines: 10` — what happens now?
- Remove `maxLines` entirely and remove `overflow: TextOverflow.ellipsis` too — what changes?
- Put them back: `maxLines: 3` and `overflow: TextOverflow.ellipsis` — the "..." at the end is called an **ellipsis**

> **Key learning:** Almost every widget in Flutter has many properties you can tweak. The way to learn them is to **try different values and see what happens**. Use `Ctrl+Space` in Android Studio after a comma inside a widget to see all available properties.

---

### Step 5: Improve the date formatting

The date currently shows as `dd MMM yyyy` (e.g. "01 Sep 2025").

Find this line in `entry_card.dart`:
```dart
DateFormat('dd MMM yyyy').format(entry.date)
```

The pattern inside the quotes controls the format. Try changing it to each of these and see what you get:
- `'EEEE, d MMMM yyyy'` — what's different? What does EEEE add?
- `'d/M/y'` — more compact
- `'MMM d'` — short and clean
- `'d MMMM'` — without the year
- `'EEE, d MMM'` — try to guess what this will look like before you save

Pick the format you like most and keep it.

> **Reference:** [docs/flutter-cheatsheet.md](../docs/flutter-cheatsheet.md) has a section on date formatting if you want to explore more patterns.

---

### Step 6: Rearrange the layout — put title and date on the same line

Right now the title, a gap (`SizedBox`), and the date are stacked **vertically** inside a `Column`. We want the title on the **left** and the date on the **right**, on the **same line**.

To do this, you need to replace three widgets (the title `Text`, the `SizedBox(height: 4)`, and the date `Text`) with a single `Row` widget.

Here are the concepts you need:
- `Row` places children **horizontally** instead of vertically
- `MainAxisAlignment.spaceBetween` pushes children to opposite ends
- `Expanded` makes a widget take up all remaining space (prevents overflow if the title is long)
- `TextOverflow.ellipsis` on the title truncates long titles with "..."

**Your task:** Build a `Row` that puts the title on the left and the date on the right. Here's the skeleton — fill in the children:

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // TODO: Put the title Text here, wrapped in Expanded
    // TODO: Put the date Text here
  ],
),
```

Hints if you're stuck:
- `Expanded(child: Text(...))` wraps a Text widget so it doesn't overflow
- The title Text should keep its bold styling
- Create a variable for the formatted date before the `return` statement: `final dateString = DateFormat('...').format(entry.date);` — then use `dateString` in the date Text widget
- Don't forget to **remove** the old title Text, SizedBox, and date Text from the Column

> **Reference:** Look at `_RowExample` in [../examples/01_layout/layout_demo.dart](../examples/01_layout/layout_demo.dart) — it shows exactly this pattern (title on left, date on right).

**Test it:** If the title is very long, does it overflow off the screen? If yes, make sure you wrapped it in `Expanded`. If the date disappears, check that the title is inside `Expanded` and the date is not.

---

## Part 3: Make it yours

### Step 7: Customize the card design

You've learned how individual widget properties work. Now combine what you know to create a card design you actually like. Here are some ideas — pick at least **two** to implement:

1. **Color bar on the left edge.** Wrap the Card's child in a `Row`, with a `Container(width: 4, color: Colors.deepPurple)` as the first child and the rest of the card content as the second child. You'll need to wrap the content in `Expanded`.

2. **Different card shape.** Try combining `shape: RoundedRectangleBorder(...)` with `margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)` on the Card.

3. **Add an icon.** Put a small `Icon(Icons.auto_stories, size: 16, color: Colors.grey)` next to the date inside your Row.

4. **Change the app theme color.** Open `lib/main.dart`, find `Color(0xFF6750A4)` and replace it with a different color. Type `Colors.` and press `Ctrl+Space` to browse named colors, or find a hex color online and use `Color(0xFFxxxxxx)`.

5. **Personalize the sample data.** Open `lib/data/sample_entries.dart` and add an 8th entry about your own experience.

---

### Step 8: Improve the empty state (optional)

Even though we have sample data now, the empty state will be shown again later when we add real persistence. Let's make it nicer.

Find the empty state in `home_screen.dart` (the `Column` with `Icons.auto_stories_outlined`).

- Change the icon — type `Icons.` in Android Studio and press `Ctrl+Space` to browse all available icons. There are thousands!
- Change the message text to something friendlier or funnier
- Try adding a `TextButton` below the message that says "Create your first memory" (it doesn't need to do anything yet — we'll wire it up in Stage 2)

---

## Android Studio tips

These shortcuts will save you a lot of time:

| Shortcut (macOS / Windows) | What it does |
|---|---|
| **Cmd+\\** / **Ctrl+\\** | Hot reload — apply code changes instantly |
| **Cmd+Shift+\\** / **Ctrl+Shift+\\** | Hot restart — restart the app from scratch |
| **Alt+Enter** | Quick fix menu — wrap with widget, remove widget, add imports, and more |
| **Ctrl+Space** | Code completion — shows all available parameters and options |
| **Cmd+Click** / **Ctrl+Click** | Navigate to source — jump to any widget or class definition |
| **Double Shift** | Search everywhere — find files, classes, symbols |
| **Cmd+Option+L** / **Ctrl+Alt+L** | Reformat code — fix indentation automatically |

> **Try it now:** click on `Card` in `entry_card.dart`, then **Cmd+Click** — you'll see all the parameters Card accepts!

---

## Optional extensions (for fast learners)

- Extract the empty-state placeholder into its own widget file `lib/widgets/empty_feed.dart` — practice creating a new file, defining a `StatelessWidget`, and importing it
- Try replacing `ListView.builder` with a plain `Column` inside a `SingleChildScrollView` — what are the differences? When would you use each? (Change it back after experimenting)
- Add a subtle gradient background to the Scaffold: research `BoxDecoration` with `LinearGradient`
- Make the cards alternate between two slightly different background colors (hint: use `index % 2 == 0` in the `itemBuilder`)

---

## Useful Flutter widgets/concepts

| Widget / concept | What it does |
|---|---|
| `ListView.builder` | Builds a list efficiently — one item at a time |
| `Card` | Rounded container with a drop shadow |
| `Column` | Stacks children vertically |
| `Row` | Places children horizontally |
| `Expanded` | Makes a child fill remaining space inside Row/Column |
| `Padding` | Adds space around a widget |
| `SizedBox(height: x)` | Adds a fixed vertical gap |
| `Container` | A box that can have color, size, padding, decoration |
| `Text` + `TextStyle` | Shows text with custom font, size, color |
| `DateFormat('pattern').format(date)` | Formats a DateTime as a String |
| `maxLines` + `overflow: TextOverflow.ellipsis` | Truncates long text with "..." |
| `Icons.some_name` | Material icon — type `Icons.` and press `Ctrl+Space` to browse |
| `Theme.of(context)` | Access the app's theme colors and text styles |
