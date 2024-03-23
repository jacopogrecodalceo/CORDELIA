#!/bin/zsh

echo "commit?"

read commit

# Navigate to the folder you want to push
cd $(dirname "$0")

cp -r "/Users/j/.local/share/nvim/site/pack/cordelia" ./vim-config

cp "/Users/j/.config/nvim/init.vim" ./vim-config

# Add all files in the folder to the Git repository
git add .

# Commit the changes
git commit -m "$commit"

# Push the changes to GitHub
git push origin main

sleep 1