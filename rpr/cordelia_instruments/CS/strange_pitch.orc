; ============
; Create as many GENs as channels
; ============
ich			filenchnls gSfile
indx		init 0
until indx == ich do
	inum init indx + 1
	itab ftgen inum, 0, 0, 1, gSfile, 0, 0, inum
	indx += 1
od

giasine		ftgen 0, 0, 16384, 9, .5, 1, 0

		instr 1
; ============
; *** INIT ***
; ============
ich			init p4
ilen_file	init ftlen(ich)/sr

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
; *** VARs ***
; ============
ibpm		init 60
icrotchet	init 60 / ibpm
itime		init icrotchet
; ============
ilo_oct		init 2
ihi_oct		init 15
idbthresh	init 9 ; dB threshold
; ============

; ============
; *** READ ***
; ============
atime		phasor (1/idur)
ain			table3 atime, ich, 1

; ============
; *** ANAL ***
; ============
koct, kamp	pitch ain, itime, ilo_oct, ihi_oct, idbthresh
kcps		= cpsoct(koct)
kamp		= kamp/pow(2, 16)

; ============
; *** OSC1 ***
; ============
kcps1		= kcps
kamp1		= kamp
aosc1		oscili 1, portk(kcps1, kport/2)
aosc1		*= kamp1
; ============
; *** OSC2 ***
; ============
kcps2		delayk kcps, itime
kamp2		delayk kamp, itime
aosc2		oscili 1, portk(kcps2, kport)
aosc2		*= kamp2

aout		= (aosc1 + aosc2/2)/2

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