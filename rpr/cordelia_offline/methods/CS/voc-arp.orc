; ============================================
; Author: 		Jacopo Greco D'Alceo
; Date: 		30/10/24
; ============================================

; ============================================
; PARAMs
; ============================================
ksmps 			= 64
giSPEED			init 1

givoc_MIN	    init 20
givoc_MAX       init 19500

givoc_Q		    init 25
givoc_BANDs	    init 40

giARP_FREQs[]    fillarray 1, 2, 3, 4

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
opcode vocoder, a, aakkki
	ain, acarrier, imin, imax, kq, inumbands xin
	ibandindexes[]  genarray 0, inumbands-1, 1
	ifreqs[]        init inumbands
	ifactor         init imax/imin
	ifactors[]      = (imax/imin) ^ (ibandindexes/inumbands)
	ifreqs[]        = imin * ifactors
	kbws[]          = ifreqs / kq

	abands_in[] poly inumbands, "butterbp", ain, ifreqs, kbws
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
; PITCH TRACKING
; ============================================
imincps			init 30
imaxcps			init 2.5*1000
kcps, krms 		pitchamdf ain, imincps, imaxcps

; ============================================
; RESYNTH
; ============================================
iarp_freq       init 1 / idur
until iarp_freq > 1 do
    iarp_freq       *= 2
od
print iarp_freq

karp_cps        = giARP_FREQs[phasor:k(iarp_freq)*lenarray(giARP_FREQs)]

aosc			vco2 krms, kcps*karp_cps

; ============================================
; VOCODER
; ============================================
aout        vocoder ain, aosc, \
			givoc_MIN, givoc_MAX, givoc_Q, givoc_BANDs
	
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
