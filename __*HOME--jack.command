#!/bin/zsh

cd "$(dirname "$0")"

poetry run sh -c 'cd cordelia && python cordelia.py --jack'