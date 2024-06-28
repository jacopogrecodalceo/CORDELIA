
gkrj_bd[]	fillarray 2, 0, 0, 0, 	1, 0, 0, 0, 	1, 0, 0, 0, 	1, 0, 0, 0
gkrj_sn[]	fillarray 0, 0, 0, 0, 	1, 0, 0, 0, 	0, 0, 0, 0, 	1, 0, 0
gkrj_ride[]	fillarray 2, 1, 1, 1, 	2, 1, 1, 1, 	2, 1, 1, 1, 	2, 1, 1


$start_instr(rj)
	idiv			init icps%i(gkdiv)
	kdiv_bar		init -1
	ksubdiv 		init -1


	; divide the main 64 quarter notes into a subdivision of 8 quarter notes
	; so from 0 to 1 now the cycle is from 0 to (64 / 8) = 8
	; representing the 8 bars
	kcycle			chnget "heart"
	kdiv_bar		= kcycle * divz(gkdiv, idiv, 1)


	; in order to get each quarter notes subdivision of 32
	; get the modulo 1 of the cycle and then multiply by 8
	ksubdiv	= (kdiv_bar % 1) * idiv

	; 4 for 16th, 8 for 32th..
	;k16th	= floor( (ksubdiv % 1) * 4 ) + 4 * floor( (gkHEART * gkdiv) )
	k16th	= floor( (ksubdiv % 1) * idiv ) + idiv * floor( (kcycle * gkdiv) )
	if changed2(k16th) == 1 then
		;kplus = random:k(0, 1) > .35 ? int(random:k(0, 2)) : 0

		kdyn_bd = gkrj_bd[k16th%lenarray(gkrj_bd)]
		if kdyn_bd >= 1 then

			kfixed_style_bd[] 	fillarray nstrnum("rj_bd"), 0, \
									kdyn_bd/4, kdyn_bd/3, ich, \
									35, 125, \
									.25, .15, \
									.75, 3, \
									.15*kdyn_bd/2, .15*kdyn_bd/5, .15, \
									.5, 10, 8

			schedulek kfixed_style_bd

		endif
	endif

endin

instr rj_bd

	Sinstr 	init 	"rj"
	idur    init    p3      ; Duration
	idyn    init    p4      ; Amplitude
	ich     init    p5      ; Channel	
	ilof    init    p6      ; Low frequency
	ihif    init    p7      ; High frequency
	idec    init    p8      ; Decay
	itens   init    p9      ; Tension
	ihit    init    p10     ; Accent
	iq      init    p11     ; Pitch Bend Q (oscillation)
	iod     init    p12     ; Amplitude of overtones
	ioc     init    p13     ; Control of overtone amplitudes
	iof     init    p14     ; Control of overtone frequencies
	isus    init    p15     ; Sustain
	iqf     init    p16     ; FM resonance frequency
	ilpf    init    p17     ; Amp low pass frequency

	; Freq Envelope
	afqc    linseg  ihif, idec, ilof, idur * -idec, ilof   ; Hi-Lo fqc sweep
	afqc2   rezzy   afqc, iqf, iq                          ; Add some ripples
	afqc3   =       afqc - afqc2 * itens                   ; Mix fqc sweep with ripples

	adyn    expseg  1, idur, isus                          ; Exp amp envelope
	adyn2   butlp   adyn, ilpf                             ; Low pass version
	adyn3   =       (adyn * ihit + adyn2 * (1 - ihit))     ; Mix the two envelopes for different attacks
	adclk   cosseg  0, .002, 1, idur - .004, 1, .002, 0    ; Declick envelope

	asig    oscil3   1, afqc3, gisine                            ; Simple sine oscillator

	ioc1    =       1 + ioc                                ; Overtone control for base fqc*2
	ioc2    =       1 + ioc * 2                            ; ditto fqc*3
	ioc3    =       1 + ioc * 3                            ; ditto fqc*5

	asig2a  oscil3   1, afqc3 * 2, gisine, .25                   ; Sine oscillator 2
	asigo   =       asig2a + .95                           ; Scale for the tanh
	asig2b  =       -tanh((asig2a + .95) * ioc1) + 1       ; Create a squarish envelope for the overtones
	asig2c  =       (asig2a * asig2b) * adyn3 ^ ioc1       ; This makes pulses of sine waves

	asig3a  oscil3   1, afqc3 * (1 + iof * 2), gisine, .25       ; Sine oscillator 3
	asig3b  =       -tanh(asigo * ioc2) + 1                ; Squarish envelope pulses
	asig3c  =       (asig3a * asig3b) * adyn3 ^ ioc2       ; Adjust the magnitude with ioc2

	asig5a  oscil3   1, afqc3 * (1 + iof * 4), gisine, .25       ; Sine oscillator 5
	asig5b  =       -tanh(asigo * ioc2) + 1                ; Squarish envelope pulses
	asig5c  =       (asig5a * asig5b) * adyn3 ^ ioc3       ; Adjust the magnitude

	; Prepare for output
	aout    =       (asig * adyn3 + (asig2c + asig3c + asig5c) * iod) * adclk * idyn

	$channel_mix
endin

instr rj_ride
	$params(rj)

	idur    init    p3              ; Duration
	idyn    init    p4              ; Amplitude
	ich     init    p5              ; Channel
	ifqc    init    p6              ; Pitch
	ifco    init    p7              ; Fco
	iq      init    p8              ; Q
	iotv    init    p9              ; Overtone volume
	iotf    init    ifco * p10      ; Fco * OTFqc
	iotq    init    iq * p11        ; Q * OTQ
	imix    init    p12

    kdclk   linseg  0, .002, 1, idur - .004, 1, .002, 0  ; Declick envelope
    kdyn    expseg  1, idur, .01
    kdyn2   linseg  0, idur * .2, 1, idur * .4, .3, idur * .4, 0
    kdyn2   =       kdyn2 * imix
    kdyn3   linseg  0, .002, 1, .004, .5, .004, 0, idur - .01, 0
    kflp    linseg  8000, .01, 5000, idur - .01, 1000

    apink	pinkish 2, 0, 20;, iseed ; Use multi-rate pink noise
	;vco xamp, xcps, iwave, kpw [, ifn]
    ; Generate impulses
    asig1   vco     1, ifqc, 2, .5, gisine, 1
    asig2   vco     1, ifqc * 1.5, 2, .5, gisine, 1

    asigl   =       (asig1 * asig2 * (1 + apink)) * kdyn + apink * kdyn2

    ; Apply resonance filters
    aoutl1  rezzy   asigl, ifco, iq, 1
    aoutl2  rezzy   asigl, iotf, iotq, 1

    ; Mix signals with overtones
    aoutl   =       aoutl1 + aoutl2 * iotv

    ; Apply low pass filter and output
    alpl    butlp   aoutl, 15000

    aout =    alpl * idyn * kdclk * 2

	$channel_mix
endin

instr rj_sn
	$params(rj)

	idur    init    p3      ; Duration
	idyn    init    p4      ; Amplitude
	ich     init    p5      ; Channel
	ifqc    init    p6  ; Pitch to frequency
	irez    init    p7      ; Tone
	ispdec  init    p8      ; Spring decay
	ispton  init    p9      ; Spring tone
	ispmix  init    p10     ; Spring mix
	ispq    init    p11     ; Spring Q
	ipbnd   init    p12     ; Pitch bend
	ipbtm   init    p13     ; Pitch bend time


	kdclk  linseg    1, idur-.002, 1, .002, 0                ; Declick envelope
	adyn   linseg    1, .2/ifqc, 1, .2/ifqc, 0, idur-.002, 0 ; An amplitude pulse
	kptch  linseg    1, ipbtm, ipbnd, ipbtm, 1, .1, 1

	aosc1   vco      1, ifqc, 2, 1, gisine, 1 ; Use a pulse of the vco to stimulate the filters
	aosc    =        -aosc1*adyn        ; Multiply by the envelope pulse
	aosc2   butterlp aosc, 12000        ; Lowpass at 12K to take the edge off

	asig1   moogvcf  aosc,    ifqc*kptch, .9*irez      ; Moof filter with high resonance for basic drum tone
	asig2   moogvcf  aosc*.5, ifqc*2.1*kptch, .75*irez ; Sweeten with an overtone

	adynr  expseg    .1, .002, 1, .2, .005

	apink1	pinkish 2, 0, 20;, iseed ; Use multi-rate pink noise
	apink2	pinkish 2, 0, 20;, iseed ; Use multi-rate pink noise

	apink1   =        apink1*2*asig1
	arndr1 delay     apink1-apink2*.6, .01

	ahp1l   rezzy    apink1+arndr1, 2700*ispton*kptch, 5*ispq, 1 ; High pass rezzy based at 2700
	ahp2l   butterbp apink1, 2000*ispton*kptch, 500/ispq  ; Generate an undertone
	ahp3l   butterbp apink1, 5400*ispton*kptch, 500/ispq  ; Generate an overtone
	ahpl    pareq    ahp1l+ahp2l*.7+ahp3l*.3, 15000, .1, .707, 2 ; Attenuate the highs a bit

	; Mix drum tones, pulse and noise signal & declick
	aout  =         (asig1+asig2+aosc2*.1+ahpl*ispmix*4)*idyn*kdclk 

	$channel_mix
	endin