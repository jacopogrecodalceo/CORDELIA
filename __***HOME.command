#!/bin/bash

if pgrep -x "csound" > /dev/null
then
    killall -9 csound
fi

Wait

IFDAC=`csound --devices -m0 &> >(egrep ".*$NAME")`

IF1="Scarlett 8i6 USB"
IF2="Scarlett 18i20 USB"
IF3="Fireface 802"
IF4="Fireface UC Mac"
IF5="Fireface UCX"
IF6="Babyface Pro"
IF7="Babyface"
IF8="Built-in Output"
IF9="Fireface UFX"

if	[[ "$IFDAC" == *"$IF1"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF1") | (egrep -o "dac\d+")`
	NCHNLS=`csound --devices -m0 &> >(egrep "$IF1") | (egrep -o "\d+.out") | (egrep -o "\d+") | tail -1`
elif	[[ "$IFDAC" == *"$IF2"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF2") | (egrep -o "dac\d+")`
	NCHNLS=`csound --devices -m0 &> >(egrep "$IF2") | (egrep -o "\d+.out") | (egrep -o "\d+") | tail -1`

elif	[[ "$IFDAC" == *"$IF3"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF3") | (egrep -o "dac\d+")`
	NCHNLS=`csound --devices -m0 &> >(egrep "$IF3") | (egrep -o "\d+.out") | (egrep -o "\d+") | tail -1`

elif	[[ "$IFDAC" == *"$IF4"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF4") | (egrep -o "dac\d+")`
	NCHNLS=`csound --devices -m0 &> >(egrep "$IF4") | (egrep -o "\d+.out") | (egrep -o "\d+") | tail -1`

elif	[[ "$IFDAC" == *"$IF5"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF5") | (egrep -o "dac\d+")`
	NCHNLS=`csound --devices -m0 &> >(egrep "$IF5") | (egrep -o "\d+.out") | (egrep -o "\d+") | tail -1`

elif	[[ "$IFDAC" == *"$IF6"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF6") | (egrep -o "dac\d+")`
	NCHNLS=`csound --devices -m0 &> >(egrep "$IF6") | (egrep -o "\d+.out") | (egrep -o "\d+") | tail -1`

elif	[[ "$IFDAC" == *"$IF7"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF7") | (egrep -o "dac\d+")`
	NCHNLS=`csound --devices -m0 &> >(egrep "$IF7") | (egrep -o "\d+.out") | (egrep -o "\d+") | tail -1`

elif	[[ "$IFDAC" == *"$IF8"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF8") | (egrep -o "dac\d+")`
	NCHNLS=`csound --devices -m0 &> >(egrep "$IF8") | (egrep -o "\d+.out") | (egrep -o "\d+") | tail -1`

elif	[[ "$IFDAC" == *"$IF9"* ]]
then
	ODAC=`csound --devices -m0 &> >(egrep "$IF9") | (egrep -o "dac\d+")`
	NCHNLS=`csound --devices -m0 &> >(egrep "$IF9") | (egrep -o "\d+.out") | (egrep -o "\d+") | tail -1`

fi

if [[ $NCHNLS -eq 2 ]]
then
	NCHNLS_end=2
	cd "$(dirname "$0")/_core" && csound cordelia.csd --nchnls="$NCHNLS_end" -o"$ODAC" -D --limiter
else
	cd "$(dirname "$0")/_core" && csound cordelia.csd -o"$ODAC" -D --limiter
fi