#!/bin/bash

csound --devices -m0 

echo "Enter dac:";read dac;cd "$(dirname "$0")/_core" && csound cordelia.csd -D --limiter -o "dac$dac" 