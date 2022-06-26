#!/bin/bash

csound --devices -m0 

echo "Enter adc:";read adc;echo "Enter dac:";read dac;cd "$(dirname "$0")/_core" && csound _livecode.csd -i "adc$adc" -o "dac$dac" -D --limiter -b 128 -B 128