#!/bin/bash

csound --devices -m0 

echo "Enter dac:";read dac;cd "$(dirname "$0")/_core" && csound _livecode.csd -D --limiter -o "dac$dac" 