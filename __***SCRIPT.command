#!/bin/zsh

cd "$(dirname "$0")/cordelia"

python3.11 "script/main_script.py"

echo "All scripts executed. Closing terminal..."
sleep 3
exit 0
