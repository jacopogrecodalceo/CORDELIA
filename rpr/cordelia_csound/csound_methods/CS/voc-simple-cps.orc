; ============================================
; Author: 		Jacopo Greco D'Alceo
; Date: 		30/10/24
; ============================================

; ============================================
; PARAMs
; ============================================
ksmps 			= 64
giSPEED			init 1
giPORT			init ksmps/ sr

givoc_MIN	    init 20
givoc_MAX       init 19500

givoc_Q		    init 48
givoc_BANDs	    init 64

; ============================================
; WINDOWs
; ============================================
gihanning   	ftgen   0, 0, 8192, 20, 2
gisine			ftgen	0, 0, 8192, 10, 1
gitri			ftgen	0, 0, 8192, 7, 0, 8192/4, 1, 8192/2, -1, 8192/4, 0
gisquare		ftgen	0, 0, 8192, 7, 1, 8192/2, 1, 0, -1, 8192/2, -1

; ============================================
; TABs
; ============================================
gifile_nchnls	filenchnls gSfile
indx            init 0
ilimit			max gifile_nchnls, nchnls
until indx == ilimit do
    ifn     = indx + 1
    ich     = (indx % (gifile_nchnls <= nchnls ? gifile_nchnls : nchnls)) + 1
    itab    ftgen ifn, 0, 0, 1, gSfile, 0, 0, ich
    prints  "FN NUMBER: %i with CHANNEL: %i\n", ifn, ich
    indx   += 1
od

; ============================================
; OPCODE
; ============================================
opcode vocoder, a, aakkkik
	ain, acarrier, imin, imax, kq, inumbands, kcps xin

	ibandindexes[]  genarray 0, inumbands-1, 1
	ibandindexes[]	= ibandindexes + 1
	
	while kcps <= 30 do
		kcps *= 2
	od

	while kcps >= 1000 do
		kcps /= 2
	od

	if kcps == 0 then
		kcps = 30
	endif

	;kcps portk kcps, giPORT

	kfreqs[]        init inumbands
	kfreqs[]        = kcps * ibandindexes
	;printarray kfreqs

	kbws[]          = kfreqs / kq

	abands_in[] poly inumbands, "butterbp", ain, kfreqs, kbws
	abands_in   poly inumbands, "butterbp", abands_in, kfreqs, kbws
	
	abands_carrier[] poly inumbands, "butterbp", acarrier, kfreqs, kbws
	abands_carrier   poly inumbands, "butterbp", abands_carrier, kfreqs, kbws

	abands[]    poly inumbands, "balance", abands_in, abands_carrier
	aout sumarray abands
	xout aout
endop

; ============================================
; INSTR
; ============================================
	instr 1 
; ============================================
; INIT
; ============================================
ifn			init p4
ich			init ifn
ilen_file	init ftlen(ifn)/ftsr(ifn)
p3			init ilen_file*giSPEED
idur		init p3

; ============================================
; READ
; ============================================
atime		phasor 1/idur
ain			table3 atime, ifn, 1

; ============================================
; PITCH TRACKING
; ============================================
imincps			init 30
imaxcps			init 2.5*1000
kcps, krms 		pitchamdf ain, imincps, imaxcps

; ============================================
; RESYNTH
; ============================================
aosc		fractalnoise krms, 1

; ============================================
; VOCODER
; ============================================
aout        vocoder ain, aosc, \
			givoc_MIN, givoc_MAX, givoc_Q, givoc_BANDs, kcps
	
	outch ich, aout/32
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
