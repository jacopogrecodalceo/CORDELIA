giDUR           init giFILE_dur
giREAD_FREQ     init (1/giFILE_dur)
giDYN           init 1/4

giBANDPASS_MODE init 1 ; 2 MODEs : 1=(alow-ahigh), 2=(ahigh-alow)

        instr 1

p3		    init giDUR
idur		init p3
ich			init p4

aread	    phasor giREAD_FREQ

ain 		table3 aread*giFILE_samp, ich
ain         *= giDYN
; ==================================================
; 1. EQ: bandpass
; ==================================================
klow        init 200
khigh       init 11500

kwet        = 1;.95 + jitter(.05, 1/8, 1/32)

alow  	    tone ain*kwet, klow + jitter(klow*11/10-klow, 1/8, 1/32)
ahigh 	    buthp ain*kwet, khigh + jitter(khigh*11/10-khigh, 1/8, 1/32)

if      giBANDPASS_MODE == 1 then
    aout	    = ain * (1-kwet) + (alow - ahigh)
elseif  giBANDPASS_MODE == 2 then
    aout	    = ain * (1-kwet) + (ahigh - alow)
endif
; ==================================================


; ==================================================
; 2. Chorus
; ==================================================
ain			= aout

idel_max    init 0.035
kdepth      init 0.0075
krate       init 0.25
kfb         init 0.95

aout	init 0
amod	oscili kdepth, krate

;ares vdelay3 asig, adel, imaxdel [, iskip]
aout	vdelay3 ain+aout*kfb, idel_max/2 + amod, idel_max
; ==================================================


; ==================================================
; 3. Reverb
; ==================================================
ain			= aout
;aoutL, aoutR reverbsc ainL, ainR, kfblvl, kfco[, israte[, ipitchm[, iskip]]] 
kfblvl         = .5 + jitter(.25, 1/8, 1/32)
kfreq_cutoff	init 3500

a1, a2      reverbsc ain, K35_hpf(ain, kfreq_cutoff, .65, 1, 2.5), kfblvl, kfreq_cutoff; + jitter(kfreq_cutoff*11/10-kfreq_cutoff, 1/8, 1/32)

aout        = ain + a1 + a2
; ==================================================

; ==================================================
; 4a. Delay
; ==================================================
ain			= aout

idel        init giFILE_dur
until idel < .25 do
	idel /= 2 
	print idel
od

kfb         = .05 + jitter(.05, 1/8, 1/32)

apre		delayr idel
adel    	deltap idel
aout 		= ain + apre

	delayw ain + adel * kfb

aout        = ain + aout
; ==================================================

; ==================================================
; 4b. Flutter
; ==================================================
ain			= aout
; subtle wow/flutter LFO
idepth1		init 3.5					
irate1 		init 1/10 ; ~0.2 Hz = wow (slow)
amod1 		oscili idepth1+jitter(1, 1/8, 1/32), irate1

idepth2		init 1.5					
irate2 		init 1/7
amod2 		oscili idepth2+jitter(.5, 1/8, 1/32), irate2

amod 		= amod1 + amod2

aout 		vdelay ain, .015 + amod, 5
; ==================================================

; ==================================================
; 5. Tape saturation
; ==================================================
ain			= aout

kdrive      = 3.5
asat        = tanh(kdrive * ain)
kwet        = .75
aout        = (1 - kwet) * ain + kwet * asat
aout        tone aout, 8500
; ==================================================

ain			= aout
acrunch       K35_hpf ain/6, 11500, .65, 1, 3.5+jitter(.5, 1/8, 1/32)

    outch ich, aout + acrunch

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
