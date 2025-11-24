givoyager2_len					init 16
gSvoyager2_dir					init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-rhy-voyager"

gkvoyager2_jit1	init 0
gkvoyager2_jit2	init 0
gkvoyager2_swing	init 0
gkvoyager2_dur	init 1
gkvoyager2_onset	init 0

; --- voyager2 groove pattern v1 ---

gkvoyager2_kick1[] fillarray 1, 0, 0, 0,  0, 1, 0, 0,  1, 0, 0, 0,  0, 0, 1, 0   ; deep grounding
gkvoyager2_kick2[] fillarray 0, 0, 0, 0,  1, 0, 0, 0,  0, 1, 0, 0,  0, 0, 0, 1   ; accent counter

gkvoyager2_snare1[] fillarray 0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 1, 0,  0, 1, 0, 0   ; elastic backbeat
gkvoyager2_snare2[] fillarray 0, 0, 0, 1,  0, 0, 1, 0,  0, 0, 0, 1,  0, 0, 0, 1   ; syncopated tail

gkvoyager2_bell[]  fillarray 0, 0, 0, 0,  0, 0, 1, 0,  0, 0, 0, 0,  0, 1, 0, 0   ; upper motif pulse

gkvoyager2_cymbal[] fillarray 1, 0, 0, 0,  0, 0, 1, 0,  0, 0, 0, 0,  1, 0, 0, 0   ; light marker

gkvoyager2_chh1[]  fillarray 1, 0, 1, 0,  1, 0, 1, 0,  1, 0, 1, 0,  1, 0, 1, 0   ; grid backbone
gkvoyager2_chh2[]  fillarray 0, 0, 0, 1,  0, 1, 0, 0,  0, 1, 0, 1,  0, 0, 0, 1   ; slight shuffle

gkvoyager2_ohh1[]  fillarray 0, 0, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1,  0, 0, 0, 0   ; airy breath
gkvoyager2_ohh2[]  fillarray 0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1   ; soft release

gkvoyager2_tom1[]  fillarray 0, 0, 0, 1,  0, 0, 0, 0,  0, 1, 0, 0,  0, 0, 0, 0   ; rolling accent
gkvoyager2_tom2[]  fillarray 0, 0, 0, 0,  0, 0, 0, 1,  0, 0, 0, 0,  1, 0, 0, 0   ; fill echo

gkvoyager2_perc1[] fillarray 0, 1, 0, 0,  0, 0, 0, 1,  0, 0, 1, 0,  0, 0, 0, 0   ; subtle texture
gkvoyager2_perc2[] fillarray 0, 0, 0, 0,  1, 0, 1, 0,  0, 0, 1, 0,  0, 1, 0, 0   ; sync detail
gkvoyager2_perc3[] fillarray 1, 0, 0, 0,  0, 1, 0, 0,  0, 0, 0, 1,  0, 0, 1, 0   ; counter grid
gkvoyager2_perc4[] fillarray 0, 0, 1, 0,  0, 0, 1, 0,  0, 0, 1, 0,  1, 0, 0, 0   ; metallic pulse
gkvoyager2_perc5[] fillarray 0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 1,  0, 0, 0, 1   ; bridge hits



#define if_voyager2(instr'dyn)#
kdyn_$instr = gkvoyager2_$instr[kdiv%givoyager2_len]
if kdyn_$instr > 0 && gkvoyager2_jit1 < 7.5 then
	schedulek Sinstr, konset, \
		1, \
		kdyn_$instr*idyn/$dyn, \
		ich, \
		sprintf("%s/%s.wav", gSvoyager2_dir, "$instr"), \
		1
endif

if gkvoyager2_jit1 > 8.5 then
	kjit_onset = konset*gkbeats
	kjit_dyn = kdyn_$instr*idyn/$dyn
	kjit_pitch = random:k(.5, 1.5)
	schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
		1, \
		kjit_dyn, \
		ich, \
		sprintf("%s/%s.wav", gSvoyager2_dir, "$instr"), \
		kjit_pitch
	if gkvoyager2_jit2 > 7.5 then
		schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
			1, \
			kjit_dyn, \
			ich, \
			sprintf("%s/%s.wav", gSvoyager2_dir, "$instr"), \
			kjit_pitch
	endif
endif
#

instr voyager2
	$params(voyager2_instrument)

	idiv			init floor(icps%8)

	; divide the main 64 quarter notes into a subdivision of 8 quarter notes
	; so from 0 to 1 now the cycle is from 0 to (64 / 8) = 8
	; representing the 8 bars
	kcycle			chnget "heart"
	kdiv			floor kcycle*gkdiv*idiv

	if changed2(kdiv) == 1 then
		if kdiv % idiv*2 == 0 then
			konset = 0
		else
			konset = (gkbeats/4)*gkvoyager2_swing
		endif 
		$if_voyager2(bell'1)
		$if_voyager2(chh1'1)
		$if_voyager2(chh2'1)
		$if_voyager2(cymbal'1)
		$if_voyager2(kick1'1)
		$if_voyager2(kick2'1)
		$if_voyager2(ohh1'1)
		$if_voyager2(ohh2'1)
		$if_voyager2(perc1'1)
		$if_voyager2(perc2'1)
		$if_voyager2(perc3'1)
		$if_voyager2(perc4'1)
		$if_voyager2(perc5'1)
		$if_voyager2(snare1'1)
		$if_voyager2(snare2'1)
		$if_voyager2(tom1'1)
		$if_voyager2(tom2'1)
	endif

	if active:k("voyager2_jit") == 0 then
		schedule "voyager2_jit", 0, -idur
	endif

endin

instr voyager2_jit
	idur			abs p3
	gkvoyager2_jit1 	abs jitter(9, gkbeatf/8, gkbeatf)
	gkvoyager2_jit2 	abs jitter(9, gkbeatf/8, gkbeatf)
	if timeinsts() > idur+3.5 then
		turnoff
	endif 
endin

instr voyager2_instrument
	Sinstr 		init "voyager2"
	idyn 		init p4
	ich			init p5
	Spath 		init p6
	ipitch 		init p7

	ilen 		filelen Spath
	ionset		i gkvoyager2_onset
	idur_ratio	i gkvoyager2_dur
	p3 			init ilen*idur_ratio
	idur 		init p3
	if idur < .005 then
		turnoff
	endif

	if random:i(0, 16) > 15 then
		idur /= floor(random:i(2, 8))
	endif

	aouts[]		diskin Spath, ipitch+random:i(-.05, .05), ionset*ilen

	ichs		filenchnls Spath

	aout		= aouts[ich%ichs]
	aout		*= cosseg:a(1, idur-.005, 1, .005, 0)*idyn
	$channel_mix
endin

