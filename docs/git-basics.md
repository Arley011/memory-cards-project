# Git Basics — Push Your Project to GitHub

This guide covers the four Git commands you need on the last day to put your project online.

---

## What is Git?

Git is a tool that tracks changes to your code. Think of it like "Save + history" — every time you commit, Git remembers what your code looked like at that moment. GitHub is a website where you can store and share your Git projects.

---

## The four commands

### 1. `git status` — See what changed

```
git status
```

Shows you which files you've changed since the last commit. Run this before doing anything else to understand the current state.

You'll see output like:
```
Changes not staged for commit:
  modified:   lib/screens/home_screen.dart

Untracked files:
  lib/screens/create_entry_screen.dart
```

---

### 2. `git add .` — Stage all changes

```
git add .
```

The dot (`.`) means "add everything". This tells Git: "I want to include all my changes in the next commit."

After running this, `git status` will show your files in green under "Changes to be committed".

---

### 3. `git commit -m "..."` — Save a snapshot

```
git commit -m "My Memory Cards app — final version"
```

This saves a permanent snapshot of your code with a description message. The message should briefly describe what you built.

After committing, `git status` will say "nothing to commit, working tree clean".

---

### 4. `git push` — Upload to GitHub

```
git push origin main
```

This uploads your commits to GitHub so they're stored online and you can access them from any device.

---

## Full workflow — step by step

Here's the complete sequence you'll follow on the last day:

```bash
# 1. Check current state
git status

# 2. Stage all changes
git add .

# 3. Commit with a message
git commit -m "My Memory Cards app — Erasmus course final version"

# 4. Push to GitHub
git push origin main
```

---

## First time: connect to GitHub

If you haven't connected your project to GitHub yet, do this first:

1. Go to [github.com](https://github.com) and create a free account
2. Click **+** in the top-right → **New repository**
3. Name it `memory-cards`, leave it Public, click **Create repository**
4. GitHub shows you two commands — run them in your terminal:

```bash
git remote add origin https://github.com/YOUR_USERNAME/memory-cards.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

After this, future pushes only need `git push`.

---

## Common error messages

**`remote origin already exists`**
The remote is already set. Run `git remote -v` to see what it points to.

**`failed to push some refs`**
Your local code is behind the remote. This shouldn't happen in our setup since only you are pushing. If it does: `git pull origin main --rebase`, then push again.

**`Please tell me who you are`**
Git doesn't know your name/email yet. Run:
```bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

**Password/authentication prompt**
GitHub no longer accepts passwords. Use a **Personal Access Token** instead:
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token → check `repo` scope → copy the token
3. Use the token as your password when prompted

---

## After the course

Your code is on GitHub! To continue working on it on another computer:

```bash
git clone https://github.com/YOUR_USERNAME/memory-cards.git
cd memory-cards/starter
flutter pub get
flutter run
```
