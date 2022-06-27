#!/bin/zsh

NAME=`basename "$0" | cut -f 1 -d '.' | cut -c 3-`

echo "Word?"
read ANS

cd "$(dirname "$0")"/_scripts/_
ruby "$NAME".rb $ANS

$SHELL