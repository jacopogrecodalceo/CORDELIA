; ============
; Create as many GENs as channels
; ============
ich			filenchnls gSfile
indx		init 1
until indx > ich do
	itab ftgen indx, 0, 0, 1, gSfile, 0, 0, indx
	print indx
	indx += 1
od

		instr 1
; ============
; *** VARs ***
; ============

ilen_file	init ftlen(p4)/ftsr(p4)
p3			init ilen_file
idur		init .125

iarr[]		init ilen_file/idur
ilen_arr	lenarray iarr

ivar		init 5
iramp		init .0025

indx	init 0
while indx < ilen_arr do
	iarr[indx] = indx*idur
	indx += 1
od

indx	init 0
while indx < ilen_arr do
	ipitch init 1
	if random(0, 32) > 30 then
		ipitch init 1/2
	endif
	schedule 2, limit(iarr[indx]-iramp, 0, ilen_file), 1, p4,\
		iarr[limit(indx+random:i(-ivar, ivar), 0, ilen_arr-1)],\ ; START
		idur*int(random(1, 4)),\ ; DUR
		ipitch,\
		iramp

	indx += 1
od

	turnoff

		endin
	
	instr 2
; ============
; *** INIT ***
; ============

ifn			init p4
ich			init p4
ilen_file	init ftlen(ifn)/ftsr(ifn)

istart		init p5*sr
idur		init p6

ipitch		init p7

iramp		init p8

p3			init idur+iramp

andx		phasor (1/ilen_file)*ipitch
andx		*= ftlen(ifn)

aout		table3 andx+istart, ifn

if iramp > 0 then
	aenv		cosseg 0, iramp, 1, p3-(iramp*2), 1, iramp, 0
else
	aenv		= 1
endif

	outch ich, aout*aenv*.5*(1/(1/ipitch))
	endin


;---SCORE---
/* 
for i in range(1):
	code = [
		'i1',
		0,			# p2: when
		1,			# p3: dur
		ch			# p4
	]
	score.append(' '.join(map(str, code)))
*/