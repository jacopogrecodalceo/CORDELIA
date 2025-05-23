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

givoc_Q		    init 45
givoc_BANDs	    init 40

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

	if kmax < kmin then
		ktmp = kmin
		kmin = kmax
		kmax = ktmp
	endif

	if kmin == 0 then 
		kmin = 1
	endif

	if (icnt >= ibnd) goto bank
	abnd   vocoder as1,as2,kmin,kmax,kq,ibnd,icnt+1

	bank:
		kfreq = kmin*(kmax/kmin)^((icnt-1)/(ibnd-1))
		;kfreq tab icnt - 1, giFrqTable
		kbw = kfreq/kq
		an  butterbp  as2, kfreq, kbw
		an  butterbp  an, kfreq, kbw
		as  butterbp  as1, kfreq, kbw
		as  butterbp  as, kfreq, kbw
		ao balance as, an

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
; 1 = linear prediction analysis compute flag | 0 = filter coefficients
; non-zero values switch on linear prediction analysis replacing filter coefficients,
; zero switch it off, keeping current filter coefficients.
kflag 	init 1

; analysis period in samples, determining how often new coefficients are computed.
kprod 	init 64

; size of lpc input frame in samples.
isize  	init 64

; linear predictor order, range from about 30 to 100 coefficients, but larger values can also be used.
iord 	init 50		
kcfs[], krms, kerr, kf0 lpcanal ain, kflag, kprod, isize, iord, gihanning
; krms, RMS estimate of source signal
; kerr, linear prediction error (or residual)

; ============================================
; RESYNTH
; ============================================
kn_harm         int sr / 2 / kf0
klh             init 1
kmul            init .5 ; high partials - if high, remember to make less volume
agbuzz          gbuzz krms, kf0, kn_harm, klh, kmul, gisine

; ============================================
; VOCODER
; ============================================
apole       allpole agbuzz*kerr, kcfs
aout        vocoder ain, apole, \
			givoc_MIN, givoc_MAX, givoc_Q, givoc_BANDs
	
	outch ich, aout/4
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
