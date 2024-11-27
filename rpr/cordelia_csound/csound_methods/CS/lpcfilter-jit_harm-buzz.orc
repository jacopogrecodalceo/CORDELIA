; ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
gkPERIOD	init 96			; reduce if percussive !
giSIZE      init 8192
giORD       init 96         ; also the number of coefficients computed, typical lp orders may range from about 30 to 100 coefficients, but larger values can also be used.
gkFLAG      init 1          ; compute flag, non-zero values switch on linear prediction analysis replacing filter coefficients, zero switch it off, keeping current filter coefficients.

giHP_DYN	init 1/6
giNOI_WET	init 1/384		; dusty vintage
giDEL_MAX	init 1/4		; that's a flanger, longer value make it a reverb
giJIT_SAMPs	init 4096*4
giSPEED     init 1          ; [idur*ispeed]
giPITCH_MIN	init 30
giPITCH_MAX	init ntof("6B") ; ~1975Hz
; ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
giasine			ftgen	0, 0, 8192, 9, .5, 1, 0
giasquare		ftgen	0, 0, 8192, 7, 1, 8192/2, 1, 0, 0, 8192/2
; ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
ichs	filenchnls gSfile
ich		init 1
until ich > nchnls do
	itab ftgen ich, 0, 0, 1, gSfile, 0, 0, (ich-1%ichs)+1
	ich += 1
od
giFILE_sr           ftsr 1
giFILE_samp         ftlen 1
giFILE_dur          init giFILE_samp / giFILE_sr

giINSTR_dur			init giFILE_dur*giSPEED
; ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃
garead				init 0
gkcps_array[]		init nchnls
gkrms_array[]		init nchnls
; ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃

; ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃

    instr 1

; ============
; *** INIT ***
; ============
ifn			init p4
ich         init p4

; ============
; *** VARs ***
; ============
p3			init giINSTR_dur
idur		init p3
; ============

; ============
; *** READ ***
; ============
;aread		cosseg 0, idur, giFILE_samp
ain			table garead, ifn
kcps, krms	pitchamdf ain, giPITCH_MIN, giPITCH_MAX

gkcps_array[ich-1] = kcps
gkrms_array[ich-1] = krms

    endin
; ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃

; ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃

	instr CONTROL

; ────────────────────────────────────────────────────────────────────────────────────────────
; gaREAD
; ────────────────────────────────────────────────────────────────────────────────────────────
garead		linseg 0, giINSTR_dur, giFILE_samp
garead		+= a(jitter(giJIT_SAMPs, 1/giINSTR_dur, 32/giINSTR_dur))
garead		= abs(garead%giFILE_samp)

; ────────────────────────────────────────────────────────────────────────────────────────────
; gkCPS ARRAY
; ────────────────────────────────────────────────────────────────────────────────────────────
kcps_val	minarray gkcps_array
if kcps_val <= 0 then
	kcps_val maxarray gkcps_array
endif
gkcps = kcps_val

; ────────────────────────────────────────────────────────────────────────────────────────────
; gkRMS ARRAY
; ────────────────────────────────────────────────────────────────────────────────────────────
krms_val	minarray gkrms_array
if krms_val <= 0 then
	krms_val maxarray gkrms_array
endif

; Smooth envelope (longer window)
kenv 		tonek krms_val, 5    

; Transient detection
ktransient 	= max(krms_val - kenv, 0)   

; Non-linear scaling to suppress sustain
gkrms = ktransient * (1 - kenv)  ; Suppress sustain based on smoothed RMS

	endin
	schedule "CONTROL", 0, -1
; ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃

; ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃

    instr 3
; ────────────────────────────────────────────────────────────────────────────────────────────
; INIT
; ────────────────────────────────────────────────────────────────────────────────────────────
ifn			init p4
ich         init p4

p3			init giINSTR_dur
idur		init p3

; ────────────────────────────────────────────────────────────────────────────────────────────
; TABLE READ
; ────────────────────────────────────────────────────────────────────────────────────────────
ain			table garead, ifn
ain_hp		K35_hpf ain, 9500+jitter(3500, 1/idur, 3/idur), 4.5+jitter(1.5, 1/idur, 3/idur), 1, 1.5+jitter(.5, 1/idur, 3/idur)

; ────────────────────────────────────────────────────────────────────────────────────────────
; CARRIER
; ────────────────────────────────────────────────────────────────────────────────────────────
kn_harm 	divz sr / 2, gkcps, 0
acar      	buzz 0dbfs, gkcps, int(kn_harm), -1
acar_hp		K35_hpf acar, 9500+jitter:k(3500, 1/idur, 3/idur), 4.5+jitter:k(1.5, 1/idur, 3/idur), 1, 1.5+jitter:k(.5, 1/idur, 3/idur)

; ────────────────────────────────────────────────────────────────────────────────────────────
; CORE
; ────────────────────────────────────────────────────────────────────────────────────────────
alpc        lpcfilter ain+ain_hp*giHP_DYN, acar+acar_hp*giHP_DYN, gkFLAG, gkPERIOD, giSIZE, giORD
alpc_hp		K35_hpf alpc, 9500+jitter(3500, 1/idur, 3/idur), 4.5+jitter(1.5, 1/idur, 3/idur), 1, 1.5+jitter(.5, 1/idur, 3/idur)
asum		sum alpc, alpc_hp*giHP_DYN

; ────────────────────────────────────────────────────────────────────────────────────────────
; FLANGER-DELAY
; ────────────────────────────────────────────────────────────────────────────────────────────
ideltime	init idur / 8
until ideltime < giDEL_MAX do
	ideltime /= 3
od
kfb			= k(1-follow2(asum, .005, .125))*(.5+jitter(.45, 1/idur, 3/idur))
adel		flanger alpc_hp, ideltime+a(jitter(ideltime/32, 1/idur, 3/idur)), kfb

; ────────────────────────────────────────────────────────────────────────────────────────────
; NOISE
; ────────────────────────────────────────────────────────────────────────────────────────────
anoi1			fractalnoise gkrms, 1

kdust_density	= 3+jitter(1.5, 1/idur, 1); average number of impulses per second
anoi2			dust2 1, kdust_density
anoi2			chebyshevpoly  anoi2, random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1), random:i(0, 1)
anoi2			polynomial anoi2, floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2)), floor(random:i(0, 2))
anoi2			K35_hpf anoi2, 9500+jitter(3500, 1/idur, 3/idur), 5.5+jitter(1, 1/idur, 3/idur), 1, 1.5+jitter(.5, 1/idur, 3/idur)

anoi_out		sum anoi1, anoi2

anoi_del		flanger anoi_out, ideltime/64+a(jitter(ideltime/128, 1/idur, 3/idur)), kfb
anoi			sum anoi_out, anoi_del
;anoi_lpc        lpcfilter ain_hp, anoi+anoi_del, gkFLAG, gkPERIOD, giSIZE, giORD

; ────────────────────────────────────────────────────────────────────────────────────────────
; OUT
; ────────────────────────────────────────────────────────────────────────────────────────────
aout		sum asum, adel, anoi*giNOI_WET*linseg(0, idur/8, 1)
    outch ich, aout/2

    endin
; ▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃▃

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
