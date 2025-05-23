gkPERIOD	init 96			; reduce if percussive !
giSIZE      init 8192
giORD       init 96         ; also the number of coefficients computed, typical lp orders may range from about 30 to 100 coefficients, but larger values can also be used.
gkFLAG      init 1          ; compute flag, non-zero values switch on linear prediction analysis replacing filter coefficients, zero switch it off, keeping current filter coefficients.

giSPEED     init 1          ; [idur*ispeed]

giasine			ftgen	0, 0, 8192, 9, .5, 1, 0
giasquare		ftgen	0, 0, 8192, 7, 1, 8192/2, 1, 0, 0, 8192/2		; square wave 

; ============
; *** TABs ***
; ============
ichs	filenchnls gSfile
ich		init 1
until ich > nchnls do
	itab ftgen ich, 0, 0, 1, gSfile, 0, 0, (ich-1%ichs)+1
	ich += 1
od

gkcps_array[]		init nchnls
gkrms_array[]		init nchnls

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
aread		linseg 0, idur, ilen_samp
;aread		cosseg 0, idur, ilen_samp
ain			table aread, ifn
kcps, krms	pitchamdf ain, 30, ntof("4B")

gkcps_array[ich-1] = kcps
gkrms_array[ich-1] = krms

    endin

	instr 2

kcps_val	minarray gkcps_array
if kcps_val <= 0 then
	kcps_val maxarray gkcps_array
endif

gkcps = kcps_val

krms_val	minarray gkrms_array
if krms_val <= 0 then
	krms_val maxarray gkrms_array
endif

; Smooth envelope (longer window)
kenv 		tonek krms_val, 5    

; Transient detection
; Isolate transients
ktransient 	= max(krms_val - kenv, 0)   

; Non-linear scaling to suppress sustain
gkrms = ktransient * (1 - kenv)  ; Suppress sustain based on smoothed RMS

	endin
	schedule 2, 0, -1


    instr 3

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
aread		linseg 0, idur, ilen_samp
;aread		cosseg 0, idur, ilen_samp
ain			table aread, ifn
apre_in		K35_hpf ain, 9500+jitter:k(3500, 1/idur, 3/idur), 4.5+jitter:k(1.5, 1/idur, 3/idur), 1, 1.5+jitter:k(.5, 1/idur, 3/idur)

; ============
; *** CARRIER ***
; ============
;kn_harm 	divz sr / 2, gkcps, 0

acar1      	vco2 1/3, gkcps*(1+floor(table3:k(phasor:k(1/(8+jitter:k(.5, 1/idur, 3/idur))), giasine, 1)*6))
acar2      	vco2 1/3, gkcps*(1+floor(table3:k((.25+phasor:k(1/(8+jitter:k(.5, 1/idur, 3/idur)))%1), giasine, 1)*6))

acar		sum acar1*oscili:a(1, 5+jitter:k(.5, 1/idur, 3/idur), giasquare), acar2*oscili:a(1, 7+jitter:k(.5, 1/idur, 3/idur), giasquare, 1/4)
apre_car	K35_hpf acar, 9500+jitter:k(3500, 1/idur, 3/idur), 4.5+jitter:k(1.5, 1/idur, 3/idur), 1, 1.5+jitter:k(.5, 1/idur, 3/idur)

; ============
; *** CORE ***
; ============
alpc        lpcfilter ain+apre_in*2, acar+apre_car, gkFLAG, gkPERIOD, giSIZE, giORD
ahp			K35_hpf alpc, 9500+jitter:k(3500, 1/idur, 3/idur), 4.5+jitter:k(1.5, 1/idur, 3/idur), 1, 1.5+jitter:k(.5, 1/idur, 3/idur)

; ============
; *** SUM ***
; ============
asum		sum alpc, ahp


; ============
; *** DEL ***
; ============
ideltime	init idur
until ideltime < 1 do
	ideltime /= 3
od
kfb			= k(1-follow2(asum, .005, .125))*(.5+jitter:k(.45, 1/idur, 3/idur))
adel		flanger ahp, ideltime+a(jitter:k(ideltime/32, 1/idur, 3/idur)), kfb

anoi			fractalnoise gkrms, 1
anoi_del		flanger anoi, ideltime/64+a(jitter:k(ideltime/128, 1/idur, 3/idur)), kfb
anoi_lpc        lpcfilter apre_in, anoi_del, gkFLAG, gkPERIOD, giSIZE, giORD

; ============
; *** OUT ***
; ============
aout		sum asum, adel, anoi_lpc / 8
    outch ich, aout / 8

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

for i in range(1):
	code = [
		'i3',
		0,			# p2: when
		1,			# p3: dur
		ch			# p4
	]
	score.append(' '.join(map(str, code)))
*/
