gipolaris_len					init 16
gSpolaris_dir					init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-rhy-polaris"

gkpolaris_jit1	init 0
gkpolaris_jit2	init 0
gkpolaris_swing	init 0
gkpolaris_dur	init 1
gkpolaris_onset	init 0

/* gipolaris_highkick   ftgen 0, 0, gipolaris_len, -2, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0  ; highkick.wav pattern
gipolaris_kick2      ftgen 0, 0, gipolaris_len, -2, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1  ; kick2.wav pattern
gipolaris_noise2     ftgen 0, 0, gipolaris_len, -2, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0  ; noise2.wav pattern
gipolaris_snare2     ftgen 0, 0, gipolaris_len, -2, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1  ; snare2.wav pattern

gipolaris_kick1      ftgen 0, 0, gipolaris_len-1, -2, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1  ; kick1.wav pattern
gipolaris_noise_c3   ftgen 0, 0, gipolaris_len, -2, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0  ; noise-c3.wav pattern
gipolaris_noise3     ftgen 0, 0, gipolaris_len, -2, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0  ; noise3.wav pattern
gipolaris_snare3     ftgen 0, 0, gipolaris_len, -2, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1  ; snare3.wav pattern

gipolaris_kick2_c2   ftgen 0, 0, gipolaris_len-1, -2, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0  ; kick2-c2.wav pattern
gipolaris_noise1     ftgen 0, 0, 9, -2, 0, 1, 0, 0, 0, 1, 0, 0, 1  ; noise1.wav pattern
gipolaris_snare1     ftgen 0, 0, gipolaris_len, -2, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1  ; snare1.wav pattern
gipolaris_snare4     ftgen 0, 0, gipolaris_len, -2, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0  ; snare4.wav pattern

 */
gkpolaris_highkick[]   fillarray 1, 0, 1, 0, 0, 1, 0, 0, 1  ; highkick.wav pattern
gkpolaris_kick2[]      fillarray 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0  ; kick2.wav pattern
gkpolaris_noise2[]     fillarray 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0  ; noise2.wav pattern
gkpolaris_snare2[]     fillarray 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0  ; snare2.wav pattern

gkpolaris_kick1[]      fillarray 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1  ; kick1.wav pattern
gkpolaris_noise_c3[]    fillarray 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0  ; noise-c3.wav pattern
gkpolaris_noise3[]     fillarray 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0  ; noise3.wav pattern
gkpolaris_snare3[]     fillarray 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0  ; snare3.wav pattern

gkpolaris_kick2_c2[]    fillarray 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0  ; kick2-c2.wav pattern
gkpolaris_noise1[]     fillarray 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  ; noise1.wav pattern
gkpolaris_snare1[]     fillarray 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0  ; snare1.wav pattern
gkpolaris_snare4[]     fillarray 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1  ; snare4.wav pattern


#define if_polaris(instr'dyn)#
ilen_$instr		lenarray gkpolaris_$instr
klen_$instr		= ilen_$instr - floor(randomh:k(0, ilen_$instr-1, 1/16))
kdiv			= floor(((kcycle*idiv)%1)*klen_$instr)
if changed2(kdiv) == 1 then
	if kdiv % idiv*2 == 0 then
		konset = 0
	else
		konset = (gkbeats/4)*gkpolaris_swing
	endif 

	kdyn_$instr = gkpolaris_$instr[kdiv%klen_$instr]

	;kdyn_$instr = gkpolaris_$instr[kdiv%gipolaris_len]
	if kdyn_$instr > 0 && gkpolaris_jit1 < 7.5 then
		schedulek Sinstr, konset, \
			1, \
			kdyn_$instr*idyn/$dyn, \
			ich, \
			sprintf("%s/%s.wav", gSpolaris_dir, "$instr"), \
			1
	endif

	if gkpolaris_jit1 > 8.5 then
		kjit_onset = konset*gkbeats
		kjit_dyn = kdyn_$instr*idyn/$dyn
		kjit_pitch = random:k(.5, 1.5)
		schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
			1, \
			kjit_dyn, \
			ich, \
			sprintf("%s/%s.wav", gSpolaris_dir, "$instr"), \
			kjit_pitch
		if gkpolaris_jit2 > 7.5 then
			schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
				1, \
				kjit_dyn, \
				ich, \
				sprintf("%s/%s.wav", gSpolaris_dir, "$instr"), \
				kjit_pitch
		endif
	endif
endif
#

instr polaris
	$params(polaris_instrument)

	idiv			init icps

	; divide the main 64 quarter notes into a subdivision of 8 quarter notes
	; so from 0 to 1 now the cycle is from 0 to (64 / 8) = 8
	; representing the 8 bars
	kcycle			= chnget:k("heart")*gkdiv
	$if_polaris(highkick'1)
	$if_polaris(kick1'1)
	$if_polaris(kick2'1)
	$if_polaris(kick2_c2'1)
	$if_polaris(noise_c3'1)
	$if_polaris(noise1'1)
	$if_polaris(noise2'1)
	$if_polaris(noise3'1)
	$if_polaris(snare1'1)
	$if_polaris(snare2'1)
	$if_polaris(snare3'1)
	$if_polaris(snare4'1)

	if active:k("polaris_jit") == 0 then
		schedule "polaris_jit", 0, -idur
	endif

endin

instr polaris_jit
	idur			abs p3
	gkpolaris_jit1 	abs jitter(9, gkbeatf/8, gkbeatf)
	gkpolaris_jit2 	abs jitter(9, gkbeatf/8, gkbeatf)
	if timeinsts() > idur+3.5 then
		turnoff
	endif 
endin

instr polaris_instrument
	Sinstr 		init "polaris"
	idyn 		init p4
	ich			init p5
	Spath 		init p6
	ipitch 		init p7

	ilen 		filelen Spath
	ionset_ratio		i gkpolaris_onset
	ionset				init ionset_ratio*ilen
	idur_ratio			i gkpolaris_dur
	p3 			init ilen*idur_ratio
	idur 		init p3
	if idur < .005 then
		turnoff
	endif

	if random:i(0, 16) > 15 then
		idur /= floor(random:i(2, 8))
	endif

	if (idur + ionset) > ilen*3/2 then
		ipitch *= -1
	endif

	aouts[]		diskin Spath, ipitch+random:i(-.05, .05), ionset

	ichs		filenchnls Spath

	aout		= aouts[ich%ichs]
	aout		*= cosseg:a(1, idur-.005, 1, .005, 0)*idyn
	$channel_mix
endin

