#!/bin/bash

if pgrep -x "csound" > /dev/null
then
    killall -9 csound
fi


IFDAC=`csound --devices -m0 &> >(egrep ".*$NAME")`

IF1="Scarlett 8i6 USB"
IF2="Scarlett 18i20 USB"
IF3="Fireface 802"
IF4="Fireface UC Mac"
IF5="Fireface UCX"
IF6="Babyface Pro"
IF7="Babyface"
IF8="Built-in Output"

if	[[ "$IFDAC" == *"$IF1"* ]]
then
	IADC=`csound --devices -m0 &> >(egrep "$IF1") | (egrep -o "adc\d+")`

elif	[[ "$IFDAC" == *"$IF2"* ]]
then
	IADC=`csound --devices -m0 &> >(egrep "$IF2") | (egrep -o "adc\d+")`

elif	[[ "$IFDAC" == *"$IF3"* ]]
then
	IADC=`csound --devices -m0 &> >(egrep "$IF3") | (egrep -o "adc\d+")`

elif	[[ "$IFDAC" == *"$IF4"* ]]
then
	IADC=`csound --devices -m0 &> >(egrep "$IF4") | (egrep -o "adc\d+")`

elif	[[ "$IFDAC" == *"$IF5"* ]]
then
	IADC=`csound --devices -m0 &> >(egrep "$IF5") | (egrep -o "adc\d+")`

elif	[[ "$IFDAC" == *"$IF6"* ]]
then
	IADC=`csound --devices -m0 &> >(egrep "$IF6") | (egrep -o "adc\d+")`

elif	[[ "$IFDAC" == *"$IF7"* ]]
then
	IADC=`csound --devices -m0 &> >(egrep "$IF7") | (egrep -o "adc\d+")`

elif	[[ "$IFDAC" == *"$IF8"* ]]
then
	IADC=`csound --devices -m0 &> >(egrep "$IF8") | (egrep -o "adc\d+")`

fi



if	[[ "$IFDAC" == *"$IF1"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF1") | (egrep -o "dac\d+")`

elif	[[ "$IFDAC" == *"$IF2"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF2") | (egrep -o "dac\d+")`

elif	[[ "$IFDAC" == *"$IF3"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF3") | (egrep -o "dac\d+")`

elif	[[ "$IFDAC" == *"$IF4"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF4") | (egrep -o "dac\d+")`

elif	[[ "$IFDAC" == *"$IF5"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF5") | (egrep -o "dac\d+")`

elif	[[ "$IFDAC" == *"$IF6"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF6") | (egrep -o "dac\d+")`

elif	[[ "$IFDAC" == *"$IF7"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF7") | (egrep -o "dac\d+")`

elif	[[ "$IFDAC" == *"$IF8"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF8") | (egrep -o "dac\d+")`

fi


cd "$(dirname "$0")/_core" && csound _livecode.csd -b 128 -B 128 -i "$IADC" -o"$ODAC" -D --limiter
