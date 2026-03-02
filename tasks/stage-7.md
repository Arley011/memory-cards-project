# Stage 7 — Git Push + Final Demo

## Today's goal
Push your project to GitHub so you can continue working on it at home, then present your app to the group.

---

## Part 1 — Push to GitHub

### Step 1: Create a GitHub account
If you don't have one yet, go to [github.com](https://github.com) and create a free account.

---

### Step 2: Create a new repository on GitHub
1. Click the **+** button in the top-right corner → **New repository**
2. Repository name: `memory-cards`
3. Leave it **Public** (or Private if you prefer)
4. **Do not** check "Add a README file" — your project already has one
5. Click **Create repository**

GitHub will show you a page with two commands — keep it open, you'll need it in Step 4.

---

### Step 3: Check your project status
Open the terminal in VS Code (`Terminal → New Terminal`).

Run:
```
git status
```

You should see a list of changed files. That's everything you built!

---

### Step 4: Stage and commit your work
```
git add .
git commit -m "My Memory Cards app — Erasmus course final version"
```

After the commit, run `git status` again — it should say "nothing to commit".

---

### Step 5: Push to GitHub
Copy the two commands from the GitHub page (they look like this — use YOUR version from GitHub):
```
git remote add origin https://github.com/YOUR_USERNAME/memory-cards.git
git push -u origin main
```

Go back to github.com and refresh the page — your project files should be there!

> **Reference:** [../docs/git-basics.md](../docs/git-basics.md) for a quick reminder of what each command does.

---

## Part 2 — Final demo

Each student presents their app for **3 minutes**. Keep it simple:

1. **Open the app** on the device/emulator
2. **Create a new entry** — title, text, date, tags (live)
3. **Close and reopen the app** — show that the entry is still there
4. **Show one feature you're proud of** — maybe a tag, a photo, search, or a notification

There's no right or wrong here — show what you built.

---

## Part 3 — Reflection

Think about these questions (you don't have to answer all of them — just the ones that feel relevant):

- **What was the hardest part this week?**
- **What surprised you most about Flutter or programming?**
- **What would you add next if you had one more day?**
- **Did anything feel satisfying — a moment when something finally worked?**

---

## Optional extensions (for those who finish early)
- Add an app icon (replace the default Flutter icon in `android/app/src/main/res/`)
- Implement "Edit entry" — tap a card to open it in the Create Entry screen pre-filled
- Add a "Favorites" feature — a star button on the card, filtered list view
- Group entries by month in the feed (hint: `ListView` with custom headers)
- Add an export feature — share the text of an entry via the device's share sheet (`Share.share(text)` from the `share_plus` package)

---

## Checkpoint outcome
Your code is on GitHub. You gave a short demo. You know at least one thing you would add next.

**Well done — you built a real app!**
