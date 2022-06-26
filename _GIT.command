#!/bin/bash

echo "What have you done?"

read commit

git add .

git commit -m "$commit"

git push

exit