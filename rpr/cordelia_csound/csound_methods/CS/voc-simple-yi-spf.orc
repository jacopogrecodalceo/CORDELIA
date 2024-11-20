; ============================================
; Author: 		Jacopo Greco D'Alceo
; Date: 		30/10/24
; ============================================

; ============================================
; PARAMs
; ============================================
ksmps 			= 64
giSPEED			init 1
giPORT			init 1/16

givoc_MIN	    init 20
givoc_MAX       init 19500

givoc_Q		    init 1/24
givoc_BANDs	    init 32

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
opcode vocoder, a, aakkkpp
	as1, as2, kmin, kmax, kq, ibnd, icnt  xin

	a0 init 0

	if kmax < kmin then
		ktmp = kmin
		kmin = kmax
		kmax = ktmp
	endif

	if kmin == 0 then 
		kmin = 1
	endif

	if (icnt >= ibnd) goto bank
	abnd   vocoder as1, as2, kmin, kmax, kq, ibnd, icnt+1

	bank:
		kfreq = kmin*(kmax/kmin)^((icnt-1)/(ibnd-1))

		an 	spf a0, a0, as2, 		kfreq, abs(jitter:k(kq, 1/32, 1))
		an 	spf a0, a0, an, 		kfreq, abs(jitter:k(kq, 1/32, 1))
		as 	spf a0, a0, as1, 		kfreq, abs(jitter:k(kq, 1/32, 1))
		as 	spf a0, a0, as, 		kfreq, abs(jitter:k(kq, 1/32, 1))

		; kq = xR -- filter damping factor, which controls peaking (for bandpass, R = 1/Q, where Q is the ratio of centre frequency and bandwidth).
		; A value of sqrt(2) (approx 1.414) gives no peaking (Butterworth response), and lower values will make the filter peak and ring. 
		; A value of 0 turns the filter into a sinusoidal oscillator. Valid values in the range of 0 - 2.
		; At 2, the filter has real poles and so it is equivalent to two first-order filters in series.

		//an  butterbp  as2, kfreq, kq
		//an  butterbp  an, kfreq, kq
		//as  butterbp  as1, kfreq, kq
		//as  butterbp  as, kfreq, kq

		ao 	balance2 as, an

	amix = ao + abnd
    xout amix
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
aosc			vco2 krms, portk(kcps, giPORT+jitter(giPORT/32, 1/p3, 24/p3)), 0, 6
anoi			fractalnoise krms, 1

asum			sum aosc, anoi

; ============================================
; VOCODER
; ============================================
while kcps > imaxcps / 2 do
	kcps /= 2
od

aout        vocoder ain, asum, \
			kcps, givoc_MAX, givoc_Q, givoc_BANDs
	
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
