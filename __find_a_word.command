#!/bin/zsh

NAME=`basename "$0" | cut -f 1 -d '.' | cut -c 3-`

echo "Word?"
read ANS

cd "$(dirname "$0")"/_core/__scripts/__others
ruby "$NAME".rb $ANS

$SHELL