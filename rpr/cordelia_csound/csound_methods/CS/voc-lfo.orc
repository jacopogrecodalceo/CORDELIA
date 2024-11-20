; ============================================
; Author: 		Jacopo Greco D'Alceo
; Date: 		31/10/24
; ============================================

; ============================================
; PARAMs
; ============================================
ksmps 			= 64
giSPEED			init 1
giPORT			init 1/16

givoc_MIN	    init 20
givoc_MAX       init 19500

givoc_Q		    init 45
givoc_BANDs	    init 30

giLFO_freqratio	init 1
giLFO_wave		init 2
// itype = 0 - sine
// itype = 1 - triangles
// itype = 2 - square (bipolar)
// itype = 3 - square (unipolar)
// itype = 4 - saw-tooth (unipolar - up)
// itype = 5 - saw-tooth (unipolar - down)

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
opcode vocoder, a, aakkkii
	ain, acarrier, imin, imax, kq, inumbands, ifreq xin
	ibandindexes[]  genarray 0, inumbands-1, 1
	ifreqs[]        init inumbands
	ifactor         init imax/imin
	itmp[]          = ibandindexes / inumbands
	ifactors[]      = (imax/imin) ^ (ibandindexes/inumbands)
	ifreqs[]        = imin * ifactors
	kbws[]          = ifreqs / kq

	abands_in[] poly inumbands, "butterbp", ain, ifreqs*(1+lfo(.25, ifreq*giLFO_freqratio, giLFO_wave)), kbws
	abands_in   poly inumbands, "butterbp", abands_in, ifreqs, kbws
	
	abands_carrier[] poly inumbands, "butterbp", acarrier, ifreqs, kbws
	abands_carrier   poly inumbands, "butterbp", abands_carrier, ifreqs, kbws

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
; CARRIER
; ============================================
adyn		follow2 ain, .005, .125
aosc		fractalnoise 0dbfs, 1
aosc		*= adyn

; ============================================
; VOCODER
; ============================================
ilfo_freq       init 1 / idur
until ilfo_freq > 1 do
    ilfo_freq       *= 2
od
aout        vocoder ain, aosc, \
			givoc_MIN, givoc_MAX, givoc_Q, givoc_BANDs, ilfo_freq
	
	outch ich, aout/8
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