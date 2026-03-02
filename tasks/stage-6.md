# Stage 6 — Stabilization + Polish

> **Before you start:** Make sure your Stage 5 track feature is working. If it's not, finish it first — this stage is about polishing, not building new features.

## Today's goal
Fix bugs, make the app reliable, and improve its visual quality so it is demo-ready tomorrow.

## What the app will look like at the end
Every core feature works reliably. The UI looks clean and consistent — good spacing, readable text, clear buttons. You can confidently show the app to someone without hitting a crash or a visual issue.

---

## Part 1 — Bug audit checklist

Work through this list. For each item, test it on the device and fix any issues you find.

**Core functionality:**
- [ ] Create an entry with a title and text → it appears in the feed
- [ ] Restart the app → the entry is still there (persistence works)
- [ ] Delete an entry → it disappears from the feed and doesn't come back after restart
- [ ] Create an entry with no title → the validation error message appears
- [ ] Navigate to Create Entry and press Back without saving → no empty entry is added
- [ ] Pick a date using the date picker → future dates should not be selectable

**UI edge cases:**
- [ ] Create an entry with a very long title (100+ characters) → the card handles it gracefully (truncation or wrapping)
- [ ] Create an entry with 10+ entries in the feed → the list scrolls without issues
- [ ] Open the app with no entries saved → the empty state is shown (not a blank screen)
- [ ] Rotate the device (if possible) → the layout doesn't break

**Stage 4 + 5 specific:**
- [ ] Tags appear correctly on cards after restart (they survive JSON serialization)
- [ ] (Track A) Photo appears on the card and survives restart
- [ ] (Track B) Search returns to full list when cleared
- [ ] (Track C) Notification toggle state is visible in Settings and survives app restart

---

## Part 2 — UI polish ideas

Pick 2–3 of these to improve:

**Spacing:**
- Use a consistent `padding: EdgeInsets.all(16)` everywhere. Check every screen.
- Add `SizedBox(height: 16)` between form fields if they look crowded.

**Empty state:**
- Make the empty state more personal — change the text to something encouraging.
- Add a call-to-action button directly in the empty state (not just the FAB).

**Typography:**
- Make the card title slightly larger or bolder — it should stand out from the body text.
- Use `Theme.of(context).textTheme` styles consistently instead of hardcoding font sizes.

**Buttons and actions:**
- Make sure every button has a clear label (avoid icon-only buttons without tooltips).
- Check that the FAB tooltip text is helpful.

**Card design:**
- Consider adding a subtle divider or color accent to make cards visually distinct.
- If entries have no text, show "No description" in grey instead of nothing.

---

## Part 3 — Code quality (optional, for faster students)

- Find any duplicated code and move it into a shared widget or function.
- Check that all `TextEditingController` objects are disposed in `dispose()`.
- Remove any unused imports (VS Code will show them in grey).
- Look for any TODOs you didn't complete and either finish them or remove the comment.

---

## Checkpoint outcome
Your app is demo-ready. You can open it, create an entry, show it to a classmate, close and reopen it — everything works and looks good.
