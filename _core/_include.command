#!/bin/bash

DIR="$(dirname "$0")"
FILE_INCLUDE="$DIR"/_livecode-include.csd
FILE_LIVECODING="$DIR"/_livecode.csd
FILE_SCORE="$DIR"/_score.csd
FILE_SCOREup="$DIR"/_scoreup.csd

> "$FILE_INCLUDE"

cp -p "$DIR"/_livecode-settings.csd "$FILE_LIVECODING"

#	MAIN FOLDER
find "$DIR" -maxdepth 1 -type f -name "*.orc" |
sed -e 's/^/#include "/' |
sed -e 's/$/"/' | 
sort >> "$FILE_INCLUDE"

#	FXs
: <<'END'
find "$DIR"/__fx -type f -name "_*.orc" |
sed -e 's/^/#include "/' |
sed -e 's/$/"/' | 
sort >> "$FILE_INCLUDE"
END

#	GENs
find "$DIR"/__gen -type f -name "*.orc" |
sed -e 's/^/#include "/' |
sed -e 's/$/"/' | 
sort >> "$FILE_INCLUDE"

#	OPCODEs
find "$DIR"/__opcode -type f -name "*.orc" |
sed -e 's/^/#include "/' |
sed -e 's/$/"/' | 
sort >> "$FILE_INCLUDE"

#	INSTRs
find "$DIR"/__instr -type f -name "*.orc" |
sed -e 's/^/#include "/' |
sed -e 's/$/"/' | 
sort >> "$FILE_INCLUDE"

#	OTHERs
find "$DIR"/__others -type f -name "*.orc" |
sed -e 's/^/#include "/' |
sed -e 's/$/"/' | 
sort >> "$FILE_INCLUDE"


echo -e "\n#include \""$DIR"/_livecode-include.csd\"" >> "$FILE_LIVECODING"

cp "$DIR"/_livecode.csd "$FILE_SCORE"

cp "$DIR"/_livecode.csd "$FILE_SCOREup"

echo -e "\n</CsInstruments>\n</CsoundSynthesizer>" >> "$FILE_LIVECODING"

echo -e "\n</CsInstruments>\n<CsScore>\n</CsScore>\n</CsoundSynthesizer>" >> "$FILE_SCORE" ;

#ruby /Users/j/Documents/PROJECTs/IDRA/_core/__scripts/__others/list_instr.rb

exit