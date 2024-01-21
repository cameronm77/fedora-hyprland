#!/bin/bash

# Change directory to your git repository
cd ~/Obsidian/Galactic\ Core/ || { notify-send 'Failed to change directory'; exit 1; }

# Pull the latest changes from GitHub
echo "Pulling latest changes from GitHub..."
if git pull; then
  notify-send 'Git pull completed'
else
  notify-send 'Git pull failed'
  exit 1
fi

# Run Obsidian
echo "Launching Obsidian..."
flatpak run md.obsidian.Obsidian || { notify-send 'Failed to launch Obsidian'; exit 1; }

# After Obsidian closes, push any changes to GitHub
echo "Pushing changes to GitHub..."
git add .
if git commit -m "Auto commit on `date +'%Y-%m-%d %H:%M:%S'`"; then
  if git push; then
    notify-send 'Git push completed'
  else
    notify-send 'Git push failed'
    exit 1
  fi
else
  notify-send 'Git commit failed'
  exit 1
fi

