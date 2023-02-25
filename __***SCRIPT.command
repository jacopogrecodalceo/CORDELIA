#!/bin/zsh

cd "$(dirname "$0")/_setting/_script"

for f in *.rb
do
  ruby "$f"
done
