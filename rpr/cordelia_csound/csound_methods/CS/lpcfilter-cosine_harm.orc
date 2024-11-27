gkPERIOD	init 96			; reduce if percussive !
giSIZE      init 8192
giORD       init 96         ; also the number of coefficients computed, typical lp orders may range from about 30 to 100 coefficients, but larger values can also be used.
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
; *** READ ***
; ============
;aread		linseg 0, idur, ilen_samp
aread		cosseg 0, idur, ilen_samp
ain			table aread, ifn
apre_in		K35_hpf ain, 9500+jitter:k(3500, 1/idur, 3/idur), 4.5+jitter:k(1.5, 1/idur, 3/idur), 1, 1.5+jitter:k(.5, 1/idur, 3/idur)

; ============
; *** CARRIER ***
; ============
kcps, krms	pitchamdf apre_in, 30, 3500
kn_harm 	divz sr / 2, kcps, 0
acar      	buzz 0dbfs, kcps, kn_harm, -1
apre_car	K35_hpf acar, 9500+jitter:k(3500, 1/idur, 3/idur), 4.5+jitter:k(1.5, 1/idur, 3/idur), 1, 1.5+jitter:k(.5, 1/idur, 3/idur)

; ============
; *** CORE ***
; ============
alpc        lpcfilter ain+apre_in*2, apre_car, gkFLAG, gkPERIOD, giSIZE, giORD
ahp			K35_hpf alpc, 9500+jitter:k(3500, 1/idur, 3/idur), 4.5+jitter:k(1.5, 1/idur, 3/idur), 1, 1.5+jitter:k(.5, 1/idur, 3/idur)

; ============
; *** SUM ***
; ============
asum		sum alpc, ahp*9

ideltime	init idur
until ideltime < 1 do
	ideltime /= 3
od

; ============
; *** DEL ***
; ============
kfb			= k(1-follow2(asum, .005, .125))*(.5+jitter:k(.45, 1/idur, 3/idur))
adel		flanger ahp, ideltime+a(jitter:k(ideltime/32, 1/idur, 3/idur)), kfb

; ============
; *** OUT ***
; ============
aout		sum asum, adel
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