# Memory Cards (Visual Journal) — Program Overview

## Project theme
**Memory Cards (Visual Journal)** is a small application where students store simple personal entries (“memory cards”).  
Each entry consists of:
- Title
- Short text
- Date

Optional additions (for faster students) can include photo attachment, categories/tags, search/filter, and other enhancements.

This theme is chosen because it:
- is easy to understand,
- produces visible results quickly,
- supports both a minimal version and extended versions without changing the core idea.

## What students will do
Students will work on their own copy of the same starter project. Each day they implement one new part of the app.  
They will spend most of the day building, debugging, and improving their project, with the mentor available for questions and short check-ins.

## Daily structure (typical day)
- **Short introduction (10–20 minutes):** goal of the day, demonstration of the expected result, and explanation of the minimum required outcome.
- **Independent work (main part of the day):** students implement tasks.
- **Mentor support:** individual help when needed, plus quick “checkpoints” to ensure nobody is blocked for too long.
- **End-of-day wrap-up:** ensure the group reaches a stable “checkpoint version” that becomes the base for the next day.

## Preparation and materials (mentor responsibilities)
Before the program starts, I will prepare a single Git repository that contains:
- A starter project template for students to copy and use as their base.
- Step-by-step setup instructions (install tools, configure environment, run the project).
- Daily task descriptions (what to build each day, minimum goal, optional extensions).
- Small demo/example projects (separate from the starter) that show the basic building blocks used in each stage (UI layout, lists, navigation, forms, saving data, optional features).  
  Students can reference these examples when stuck rather than receiving full solutions.
- Troubleshooting notes for common setup and runtime issues.

---

## Stage 1 — First screen + UI basics (read-only prototype)

### Core (must-have)
- Set up the environment (VS Code + Flutter), run the starter project and understand the **edit → hot reload → see result** loop.
- Build the main screen (Timeline/Feed) with a header/title and a “+” button.
- Display a list of example entries (hardcoded sample data) as “cards”.
- Practice basic layout and styling: spacing (padding/margins), alignment, text styles, colors, card shape.
- Use at least two layout approaches: **Column/Row** and a scrollable list (List-style view).

### Optional (if faster)
- Add a second layout variant for entries (e.g., compact vs. expanded card).
- Add an empty state UI (“no entries yet”).
- Add a simple grid view mode (toggle list ↔ grid).
- Add a theme switch (light/dark) or a consistent color palette choice.
- Make a reusable “EntryCard” component to reduce duplication.

### Checkpoint outcome
A usable, visually clean feed screen that already looks like a real app, even though data is still mock.

---

## Stage 2 — Create entry flow (first interaction + state update)

### Core (must-have)
- Add a “Create Entry” screen.
- Add input fields: title and text; add a date selector (date picker).
- Navigation between screens: open “Create Entry”, then return to the feed.
- On save: the new entry appears in the feed immediately (state change).
- Basic validation: title required (and optionally a min length), show a simple user-friendly message when invalid.

### Optional (if faster)
- Add “Cancel” flow with confirmation if text was typed.
- Add a **Mood** field (emojis / one–two words). Show it on the card as a label.
- Add “Edit entry” (tap a card to open and update it).
- Add “Details view” (tap a card to view it full-screen).
- Add simple sorting (newest first) after adding.

### Checkpoint outcome
The app supports creating entries and immediately seeing them in the feed during the same run.

---

## Stage 3 — Persistence (save data locally)

### Core (must-have)
- Make entries persist: after restarting the app, previously created entries are still there (use a simple local storage approach, e.g., `shared_preferences`).
- Load saved entries on app start and show them in the feed.
- Add delete functionality (at least one clear way: long-press, context menu, or swipe).

### Optional (if faster)
- Add “Undo delete” message after removal.
- Add simple data model improvements: unique ID, createdAt vs selected date.
- Add “Clear all entries” with confirmation (for testing).
- Add basic error handling: if loading fails, show a friendly message.

### Checkpoint outcome
Students now have a “real” app: data survives restarts and basic management (add/delete) works.

---

## Stage 4 — Quality + structure (tags/categories, better usability)

### Core (must-have)
- Introduce categories/tags for entries (e.g., Erasmus, Food, Travel, Ideas).
- Choose a tag when creating an entry and display it on the card (badge/label).
- Improve usability/visual clarity: consistent spacing, readable typography, improved empty state.
- Refactor UI structure slightly: keep the feed screen clean and reuse components where possible.

### Optional (if faster)
- Filter by tag (show only “Travel”, etc.).
- Add search by title/text (simple search field).
- Create categories with colors dynamically during the entry creation.
- Add better list interactions (swipe actions, tap animations).

### Checkpoint outcome
The app feels more personal and organized; students see how features evolve beyond the base version.

---

## Stage 5 — One feature milestone (choose a track)

One main track for the day depending on group pace and interest.

### Track A: Photo attachment

#### Core (must-have)
- Allow adding a photo to an entry (camera or gallery).
- Show a thumbnail preview on the entry card.

#### Optional (if faster)
- List of photos.
- Full-screen photo preview.
- Replace/remove photo.
- Comment for the attached photo.

### Track B: Discovery features

#### Core (must-have)
- Implement search and/or filters in the feed.
- Show “no results” UI state.

#### Optional (if faster)
- Multiple filters combined (tag + search).
- Sorting options (date ascending/descending).
- Highlight matches in search results.

### Track C: Daily reminder

#### Core (must-have)
- Use a package for local push notifications and set up a daily reminder.
- Create a settings screen where you can turn on/off the reminder.

#### Optional (if faster)
- Handle reminder notification tap to pre-open the new entry creation screen.
- Add ability to change the time of reminder.
- Add ability to add more than one reminder.

### Checkpoint outcome
A noticeable feature upgrade that makes the app more exciting.

---

## Stage 6 — Stabilization + polish + my review/advice

### Core (must-have)
- Bug fixing and stability: ensure create/save/delete works reliably.
- UI polish pass: consistent spacing, good empty states, clear buttons/labels.

### Optional (if faster)
- Add app icon/name polish.
- Add/improve a settings screen (theme toggle, sort option).
- Add export (e.g., share text summary of an entry).

### Checkpoint outcome
The app is demo-ready and students can explain what they built.

---

## Stage 7 — Extensions + final demo + “what I learned”

### Core (must-have)
- Push code to Git so students can continue at home (simple workflow).
- Final demo by each student (quick, simple).
- Short reflection: what was hardest, what they are proud of, what they would add next.

### Optional (if faster)
- Any “star tasks” not done yet: reminders, calendar grouping, edit flow, favorites, etc.

### Checkpoint outcome
Students leave with a working app, a sense of achievement, and a clear idea of next steps.
