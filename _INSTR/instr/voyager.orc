givoyager_len					init 16
gSvoyager_dir					init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-rhy-voyager"

gkvoyager_jit1	init 0
gkvoyager_jit2	init 0
gkvoyager_swing	init 0
gkvoyager_dur	init 1
gkvoyager_onset	init 0

gkvoyager_kick1[] fillarray 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0   ; kick1.wav pattern
gkvoyager_kick2[] fillarray 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0   ; kick2.wav pattern

gkvoyager_snare1[]fillarray 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1   ; snare1.wav pattern
gkvoyager_snare2[]fillarray 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0   ; snare2.wav pattern

gkvoyager_bell[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0   ; bell.wav pattern

gkvoyager_cymbal[]fillarray 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0   ; cymbal.wav pattern

gkvoyager_chh1[]  fillarray 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0   ; chh1.wav pattern
gkvoyager_chh2[]  fillarray 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1   ; chh2.wav pattern

gkvoyager_ohh1[]  fillarray 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0   ; ohh1.wav pattern
gkvoyager_ohh2[]  fillarray 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0   ; ohh2.wav pattern

gkvoyager_tom1[]  fillarray 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1   ; tom1.wav pattern
gkvoyager_tom2[]  fillarray 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0   ; tom2.wav pattern

gkvoyager_perc1[] fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0   ; perc1.wav pattern
gkvoyager_perc2[] fillarray 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0   ; perc2.wav pattern
gkvoyager_perc3[] fillarray 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0   ; perc3.wav pattern
gkvoyager_perc4[] fillarray 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0   ; perc4.wav pattern
gkvoyager_perc5[] fillarray 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1   ; perc5.wav pattern




#define if_voyager(instr'dyn)#
kdyn_$instr = gkvoyager_$instr[kdiv%givoyager_len]
if kdyn_$instr > 0 && gkvoyager_jit1 < 7.5 then
	schedulek Sinstr, konset, \
		1, \
		kdyn_$instr*idyn/$dyn, \
		ich, \
		sprintf("%s/%s.wav", gSvoyager_dir, "$instr"), \
		1
endif

if gkvoyager_jit1 > 8.5 then
	kjit_onset = konset*gkbeats
	kjit_dyn = kdyn_$instr*idyn/$dyn
	kjit_pitch = random:k(.5, 1.5)
	schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
		1, \
		kjit_dyn, \
		ich, \
		sprintf("%s/%s.wav", gSvoyager_dir, "$instr"), \
		kjit_pitch
	if gkvoyager_jit2 > 7.5 then
		schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
			1, \
			kjit_dyn, \
			ich, \
			sprintf("%s/%s.wav", gSvoyager_dir, "$instr"), \
			kjit_pitch
	endif
endif
#

instr voyager
	$params(voyager_instrument)

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
			konset = (gkbeats/4)*gkvoyager_swing
		endif 
		$if_voyager(bell'1)
		$if_voyager(chh1'1)
		$if_voyager(chh2'1)
		$if_voyager(cymbal'1)
		$if_voyager(kick1'1)
		$if_voyager(kick2'1)
		$if_voyager(ohh1'1)
		$if_voyager(ohh2'1)
		$if_voyager(perc1'1)
		$if_voyager(perc2'1)
		$if_voyager(perc3'1)
		$if_voyager(perc4'1)
		$if_voyager(perc5'1)
		$if_voyager(snare1'1)
		$if_voyager(snare2'1)
		$if_voyager(tom1'1)
		$if_voyager(tom2'1)
	endif

	if active:k("voyager_jit") == 0 then
		schedule "voyager_jit", 0, -idur
	endif

endin

instr voyager_jit
	idur			abs p3
	gkvoyager_jit1 	abs jitter(9, gkbeatf/8, gkbeatf)
	gkvoyager_jit2 	abs jitter(9, gkbeatf/8, gkbeatf)
	if timeinsts() > idur+3.5 then
		turnoff
	endif 
endin

instr voyager_instrument
	Sinstr 		init "voyager"
	idyn 		init p4
	ich			init p5
	Spath 		init p6
	ipitch 		init p7

	ilen 		filelen Spath
	ionset		i gkvoyager_onset
	idur_ratio	i gkvoyager_dur
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

