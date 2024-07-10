

gkr909t2_bass_1[]			fillarray 	1, 0, 1, 0
gSr909t2_bass 				init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/BT0A0A7.WAV"
gir909t2_len				filelen gSr909t2_bass

; ==================================================================================
; ==================================================================================
; ==================================================================================
; ==================================================================================
; ==================================================================================

$start_instr(r909t2)
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

	if gkr909t2_bass_1[k16th%lenarray(gkr909t2_bass_1)] == 1 && changed2(k16th) == 1 then
		schedulek "r909t2_instrument", 0, gir909t2_len, idyn, ich, gSr909t2_bass
		schedulek "r909t2_instrument", random:k(0, .005), gir909t2_len*3/2, idyn/2, ich, gSr909t2_bass
	endif
endin


instr r909t2_instrument
	Sinstr 	init "r909t2"
	idur 	init p3
	idyn 	init p4
	ich		init p5
	Spath 	init p6

	adisk	diskin Spath, 1+random:i(-.05, .05)
	aosc	oscil3 cosseg:a(0, .005, 1/2), cosseg:a(random:i(65, 95), idur, random:i(35, 45)), gisine

	aout = (adisk+aosc)/2
	;aout	chebyshevpoly aout, 0, .05, .15, 1/3, .05, .175;, k6
	aout	*= cosseg:a(1, idur-.015, 1, .015, 0)*idyn
	;aout	mvclpf1 aout, ntof("8B"), .5
	;aout	zdf_2pole aout, ntof("0B"), 1, 6

	;aout	flanger aout/2, cosseg:a(0, idur, idur/random:i(950, 1050)), cosseg:k(random:i(1, 0), idur, 0)
	$channel_mix
endin

