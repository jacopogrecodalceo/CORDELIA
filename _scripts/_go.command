#!/bin/bash

for f in "$(dirname "$0")"/*.rb; do
  cd "$(dirname "$0")"
  ruby "$f" 
done

$SHELL