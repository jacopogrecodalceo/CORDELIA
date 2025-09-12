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

gifn_len	init 8192
giasquare		ftgen	0, 0, gifn_len, 7, 1, gifn_len/2, 1, 0, 0, gifn_len/2 

		instr 1
; ============
; *** INIT ***
; ============
ifn			init p4
ich			init p4
ilen_file	init ftlen(ifn)/ftsr(ifn)

; ============
; *** VARs ***
; ============
ispeed 		init 1 ; [idur*ispeed]
kport		= 0
; ============
p3			init ilen_file*ispeed
idur		init p3
; ============

; ============
; *** READ ***
; ============
atime		phasor 1/idur
ain			table3 atime, ifn, 1

kcps, krms pitchamdf ain, 35, 2500

;===================
kord 		init 425
;===================
;kfeedback 	init .95
kfeedback 	= .15 + oscil3(.75+jitter(.05, 1, 3), 1/6)
anotch		phaser1 ain, kcps, kord, kfeedback
anotch		= (ain / 12 - anotch) / 2

aout		butterhp anotch, 20

		outch ich, aout

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
