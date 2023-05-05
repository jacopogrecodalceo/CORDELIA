#!/bin/zsh

echo "commit?"

read commit

# Navigate to the folder you want to push
cd $(dirname "$0")

# Add all files in the folder to the Git repository
git add .

# Commit the changes
git commit -m "$commit"

# Push the changes to GitHub
git push origin main

sleep 1