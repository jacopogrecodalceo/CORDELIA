giSIZE      init pow(2, 10) ; 4096
giORD       init 175         ; also the number of coefficients computed, typical lp orders may range from about 30 to 100 coefficients, but larger values can also be used.
gkFLAG      init 1          ; compute flag, non-zero values switch on linear prediction analysis replacing filter coefficients, zero switch it off, keeping current filter coefficients.
giSPEED     init 1          ; [idur*ispeed]

; ============
; *** TABs ***
; ============
ichs	filenchnls gSfile
ich		init 1
until ich > nchnls do
	itab ftgen ich, 0, 0, 1, gSfile, 0, 0, (ich-1%ichs)+1
	ich += 1
od

gihanning       ftgen   0, 0, 8192, 20, 2
;gisaw			ftgen	0, 0, 8192, 7, 1, 8192, -1
gitri			ftgen	0, 0, 8192, 7, 0, 8192/4, 1, 8192/2, -1, 8192/4, 0
;gisquare		ftgen	0, 0, 8192, 7, 1, 8192/2, 1, 0, -1, 8192/2, -1
;gisine			ftgen	0, 0, 8192, 10, 1

    instr 1

; ============
; *** INIT ***
; ============
ifn			init p4
ich         init p4
ilen_samp   ftlen ifn
ilen_sec	init ftlen(ifn)/ftsr(ifn)

; ============
; *** VARs ***
; ============
p3			init ilen_sec*giSPEED
idur		init p3
; ============

; ============
; *** CORE ***
; ============
kread		linseg 0, p3, ilen_samp
kcfs[], krms, kerr, kf0 lpcanal kread, gkFLAG, ifn, giSIZE, giORD, gihanning
; ============

; ============
; *** SYNTH ***
; ============
kport       = .05
kn_harm     = sr/2/kf0
abuzz       buzz 0dbfs, portk(kf0, abs(jitter(kport, 1/12, 1))), kn_harm, gitri
; ============

aout        allpole abuzz*krms*kerr, kcfs

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