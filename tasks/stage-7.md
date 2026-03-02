# Stage 7 — Build, Git Push + Final Demo

> **Before you start:** Make sure your app runs without crashes. You should be able to create an entry, close the app, reopen it, and see the entry still there.

## Today's goal
Build a release APK you can install on your phone, push your project to GitHub, and present your app to the group.

---

## Part 1 — Build a release APK

### Step 1: Build the APK
In the terminal, run:
```
flutter build apk
```

This takes 1–3 minutes. When it finishes, you'll see a message like:
```
✓ Built build/app/outputs/flutter-apk/app-release.apk
```

The APK file is your complete app — ready to install on any Android phone.

> **Note:** This builds a "debug-signed" release APK. It's fine for personal use and sharing with friends. Publishing to the Play Store would require additional signing setup.

---

### Step 2: Install on your phone
**If you have an Android phone connected via USB:**
```
flutter install
```
This installs the APK directly on your phone. You'll find "Memory Cards" in your app drawer.

**If you want to share the APK file:**
The file is at `build/app/outputs/flutter-apk/app-release.apk`. You can:
- Send it via email, Telegram, or any messenger
- Upload it to Google Drive
- Transfer it via USB cable

To install on any Android phone: open the file, tap **Install**, and allow "Install from unknown sources" if prompted.

> **Note:** APK files only work on Android. If you're on iOS, you can still demo using the Simulator or a connected iPhone — but you can't create a standalone file to share without an Apple Developer account.

---

## Part 2 — Push to GitHub

### Step 1: Create a GitHub account
If you don't have one yet, go to [github.com](https://github.com) and create a free account.

---

### Step 2: Create a new repository on GitHub
1. Click the **+** button in the top-right corner → **New repository**
2. Repository name: `memory-cards`
3. Leave it **Public** (or Private if you prefer)
4. **Do not** check "Add a README file" — your project already has one
5. Click **Create repository**

GitHub will show you a page with setup commands — keep it open, you'll need it in Step 5.

---

### Step 3: Configure Git (first time only)
If Git doesn't know your name/email yet, run:
```
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

---

### Step 4: Stage and commit your work
```
git add .
git commit -m "My Memory Cards app — Erasmus course final version"
```

After the commit, run `git status` — it should say "nothing to commit".

> **Note:** The `.gitignore` file makes sure large build folders and temporary files are excluded automatically. You don't need to worry about them.

---

### Step 5: Push to GitHub
Copy the commands from the GitHub page (they look like this — use YOUR version from GitHub):
```
git remote add origin https://github.com/YOUR_USERNAME/memory-cards.git
git push -u origin main
```

> **Trouble?** If you get an error about `main`, try `git push -u origin master` instead — some Git versions use `master` as the default branch name.

Go back to github.com and refresh the page — your project files should be there!

> **Authentication:** GitHub will ask you to log in. The easiest way is to use the browser prompt from VS Code. If it asks for a password in the terminal, you need a **Personal Access Token** — see [docs/git-basics.md](../docs/git-basics.md) for instructions.

> **Reference:** [../docs/git-basics.md](../docs/git-basics.md) for a quick reminder of what each command does.

---

## Part 3 — Final demo

Each student presents their app for **3 minutes**. Keep it simple:

1. **Open the app** on the device/emulator (even better — open the installed APK on your phone!)
2. **Create a new entry** — title, text, date, tags (live)
3. **Close and reopen the app** — stop it in the terminal with `q` or Ctrl+C, then run `flutter run` again (or close and reopen the installed APK) — show that the entry is still there
4. **Show one feature you're proud of** — maybe a tag, a photo, search, or a notification

There's no right or wrong here — show what you built.

---

## Part 4 — Reflection

Think about these questions (you don't have to answer all of them — just the ones that feel relevant):

- **What was the hardest part this week?**
- **What surprised you most about Flutter or programming?**
- **What would you add next if you had one more day?**
- **Did anything feel satisfying — a moment when something finally worked?**

---

## Optional extensions (for those who finish early)
- Add an app icon (replace the default Flutter icon in `android/app/src/main/res/`)
- Implement "Edit entry" — tap a card to open it in the Create Entry screen pre-filled (hint: pass the entry to the screen constructor, use `copyWith` to create the updated version)
- Add a "Favorites" feature — a star button on the card, filtered list view
- Group entries by month in the feed (hint: `ListView` with custom headers)
- Add an export feature — share the text of an entry via the device's share sheet (first run `flutter pub add share_plus`, then use `Share.share(text)`)

---

## Checkpoint outcome
You have a release APK. Your code is on GitHub. You gave a short demo. You know at least one thing you would add next.

**Well done — you built a real app!**
