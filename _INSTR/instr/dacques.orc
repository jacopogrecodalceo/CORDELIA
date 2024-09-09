gidacques_len					init 16
gSdacques_dir					init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-rhy-dacques"

gkdacques_jit1	init 0
gkdacques_jit2	init 0
gkdacques_swing	init 0
gkdacques_dur	init 1
gkdacques_onset	init 0

gkdacques_kick1[] fillarray 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0   ; kick1.wav pattern
gkdacques_kick2[] fillarray 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0   ; kick2.wav pattern

gkdacques_snare1[]fillarray 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1   ; snare1.wav pattern
gkdacques_snare2[]fillarray 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0   ; snare2.wav pattern

gkdacques_bell[]  fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0   ; bell.wav pattern

gkdacques_cymbal[]fillarray 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0   ; cymbal.wav pattern

gkdacques_chh1[]  fillarray 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0   ; chh1.wav pattern
gkdacques_chh2[]  fillarray 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1   ; chh2.wav pattern

gkdacques_ohh1[]  fillarray 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0   ; ohh1.wav pattern
gkdacques_ohh2[]  fillarray 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0   ; ohh2.wav pattern

gkdacques_tom1[]  fillarray 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1   ; tom1.wav pattern
gkdacques_tom2[]  fillarray 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0   ; tom2.wav pattern

gkdacques_perc1[] fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0   ; perc1.wav pattern
gkdacques_perc2[] fillarray 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0   ; perc2.wav pattern
gkdacques_perc3[] fillarray 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0   ; perc3.wav pattern
gkdacques_perc4[] fillarray 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0   ; perc4.wav pattern
gkdacques_perc5[] fillarray 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1   ; perc5.wav pattern




#define if_dacques(instr'dyn)#
kdyn_$instr = gkdacques_$instr[kdiv%gidacques_len]
if kdyn_$instr > 0 && gkdacques_jit1 < 7.5 then
	schedulek Sinstr, konset, \
		1, \
		kdyn_$instr*idyn/$dyn, \
		ich, \
		sprintf("%s/%s.wav", gSdacques_dir, "$instr"), \
		1
endif

if gkdacques_jit1 > 8.5 then
	kjit_onset = konset*gkbeats
	kjit_dyn = kdyn_$instr*idyn/$dyn
	kjit_pitch = random:k(.5, 1.5)
	schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
		1, \
		kjit_dyn, \
		ich, \
		sprintf("%s/%s.wav", gSdacques_dir, "$instr"), \
		kjit_pitch
	if gkdacques_jit2 > 7.5 then
		schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
			1, \
			kjit_dyn, \
			ich, \
			sprintf("%s/%s.wav", gSdacques_dir, "$instr"), \
			kjit_pitch
	endif
endif
#

instr dacques
	$params(dacques_instrument)

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
			konset = (gkbeats/4)*gkdacques_swing
		endif 
		$if_dacques(bell'1)
		$if_dacques(chh1'1)
		$if_dacques(chh2'1)
		$if_dacques(cymbal'1)
		$if_dacques(kick1'1)
		$if_dacques(kick2'1)
		$if_dacques(ohh1'1)
		$if_dacques(ohh2'1)
		$if_dacques(perc1'1)
		$if_dacques(perc2'1)
		$if_dacques(perc3'1)
		$if_dacques(perc4'1)
		$if_dacques(perc5'1)
		$if_dacques(snare1'1)
		$if_dacques(snare2'1)
		$if_dacques(tom1'1)
		$if_dacques(tom2'1)
	endif

	if active:k("dacques_jit") == 0 then
		schedule "dacques_jit", 0, -idur
	endif

endin

instr dacques_jit
	idur			abs p3
	gkdacques_jit1 	abs jitter(9, gkbeatf/8, gkbeatf)
	gkdacques_jit2 	abs jitter(9, gkbeatf/8, gkbeatf)
	if timeinsts() > idur+3.5 then
		turnoff
	endif 
endin

instr dacques_instrument
	Sinstr 		init "dacques"
	idyn 		init p4
	ich			init p5
	Spath 		init p6
	ipitch 		init p7

	ilen 		filelen Spath
	ionset		i gkdacques_onset
	idur_ratio	i gkdacques_dur
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

