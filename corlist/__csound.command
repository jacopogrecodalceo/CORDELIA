#!/bin/bash

csound --devices

echo "NUM DEVICE?"
read DEV


cd "$(dirname "$0")"
csound _csound.csd -odac$DEV

exit