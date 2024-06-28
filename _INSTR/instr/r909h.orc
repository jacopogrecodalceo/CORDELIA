gkr909h_cym_crash[]			fillarray 	1, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 0, 0
gkr909h_cym_ride[]			fillarray 	0, 1, 0, 1, 	2, 0, 1, 0, 	0, 1, 0, 1, 	2, 0, 1, 0

gkr909h_hh_closed[]			fillarray 	0, 1, 1, 0, 	0, 1, 1, 2, 	0, 1, 1, 2, 	0, 1, 1, 2
gkr909h_hh_open[]			fillarray 	2, 0, 0, 0, 	2, 0, 0, 0, 	2, 0, 0, 0, 	1, 0, 0, 0																																																	
gkr909h_hh_clop[]			fillarray 	0, 1, 0, 0, 	0, 1, 0, 0, 	0, 1, 0, 0, 	0, 1, 0, 0
gkr909h_hh_opcl[]			fillarray 	0, 0, 0, 2, 	0, 0, 1, 0, 	0, 0, 1, 0, 	0, 0, 1, 0


gSr909h_hh_closed[] 			fillarray \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHCD0.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHCD2.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHCD4.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHCD6.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHCD8.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHCDA.WAV"


gSr909h_hh_open[] 			fillarray \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHOD0.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHOD2.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHOD4.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHOD6.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHOD8.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/HHODA.WAV"


gSr909h_hh_clop[]		fillarray \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/OPCL1.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/OPCL2.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/OPCL3.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/OPCL4.WAV"


gSr909h_hh_opcl[]		fillarray \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/CLOP1.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/CLOP2.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/CLOP3.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/CLOP4.WAV"



gSr909h_cym_crash[] 			fillarray \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/CSHD0.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/CSHD2.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/CSHD4.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/CSHD6.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/CSHD8.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/CSHDA.WAV"



gSr909h_cym_ride[] 			fillarray \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/RIDED0.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/RIDED2.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/RIDED4.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/RIDED6.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/RIDED8.WAV", \
	"/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/Roland TR-909/RIDEDA.WAV"

; ==================================================================================
; ==================================================================================
; ==================================================================================
; ==================================================================================
; ==================================================================================

#define if_r909h(array'dyn) #
kdyn_$array = gkr909h_$array[k16th%lenarray(gkr909h_$array)]
if kdyn_$array >= 1 then
	if gkr909h_stopper < 3.5 then
		schedulek "r909h_instrument", 0, 1, idyn*kdyn_$array/$dyn, ich, gSr909h_$array[random:k(0, lenarray(gSr909h_$array))], gkr909h_ratio
	endif

	if random:k(0, 1) > .895 then
		kvar = floor(random:k(6, 13))
		schedulek "r909h_instrument", gkbeats/kvar, 1, idyn*kdyn_$array/$dyn/kvar, ich, gSr909h_$array[random:k(0, lenarray(gSr909h_$array))], gkr909h_ratio*gkr909h_ratio
	endif

endif
#

gkr909h_stopper init 0
gkr909h_ratio	init 1

$start_instr(r909h)
	idiv			init icps%i(gkdiv)
	kdiv_bar		init -1
	ksubdiv 		init -1

	if active:i("r909h_controller") == 0 then
		schedule "r909h_controller", 0, idur
	endif

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
		$if_r909h(cym_crash'16)
		$if_r909h(cym_ride'24)
		$if_r909h(hh_open'24)
		$if_r909h(hh_closed'24)
		$if_r909h(hh_clop'16)
		$if_r909h(hh_opcl'24)
	endif

endin

instr r909h_controller
	gkr909h_stopper  random 0, 4

	gkr909h_ratio 	= random:k(0, 4) < 3.5 ? 1 : -1
endin

;#define r909h_chebyshev #int(random:i(0, -2))*random#

instr r909h_instrument
	Sinstr 	init "r909h"
	idyn 	init p4
	ich		init p5
	Spath 	init p6
	iratio 	init p7

	ilen 	filelen Spath
	p3 		init ilen
	idur 	init p3

	aout	diskin Spath, iratio+random:i(-.05, .05)
	aout	*= cosseg(0, .005, 1, p3-.01, 1, .005, 0)*idyn
	;aout	chebyshevpoly aout, 0, 1/12, -1/12, 1/32, -1/32, -1/2
	;aout	flanger aout/2, cosseg:a(0, idur, idur/random:i(950, 1050)), cosseg:k(random:i(1, 0), idur, 0)
	;aout 	limit aout/2, -.95, 95
	$channel_mix
endin

