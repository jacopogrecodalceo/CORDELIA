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

gisine			ftgen 0, 0, 8192, 10, 1

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
; *** VARs ***
; ============
ibpm		init 60
iquarter	init 60 / ibpm
itime		init iquarter/32
; ============
ilo_oct		octcps 20
ihi_oct		octcps sr/2
idbthresh	init 9 ; dB threshold
; ============

; ============
; *** READ ***
; ============
atime		phasor (1/idur)
ain			table3 atime, ifn, 1

; ============
; *** ANAL ***
; ============
koct, kamp	pitch ain, itime, ilo_oct, ihi_oct, idbthresh
kcps		cpsoct koct
kamp		= kamp/pow(2, 16)

; ============
; *** TRSHIFT ***
; ============
ipv_size		init 4096
ipv_hop			init ipv_size/4
ipv_win			init 1 ; O: Hamming, 1: Hanning
ffr, fph		pvsifd	ain, ipv_size, ipv_hop, ipv_win
fsig			partials ffr, fph, .00125, 1, 15, ipv_size

fsig			trshift fsig, kcps

aout			tradsyn fsig, 1, 1, ipv_size, gisine

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
