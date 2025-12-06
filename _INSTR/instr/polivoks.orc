gkpolivoks_len					init 14
gSpolivoks_dir					init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-rhy-polivoks"

gkpolivoks_jit1	init 0
gkpolivoks_jit2	init 0
gkpolivoks_swing	init 0
gkpolivoks_dur	init 1
gkpolivoks_onset	init 0

; --- polivoks groove pattern v1 ---

gkpolivoks_bd_analog1[] fillarray 1, 0, 0, 0,  0, 1, 0, 0,  1, 0, 0, 0,  0, 0, 1, 0   ; deep grounding
gkpolivoks_bd_analog2[] fillarray 0, 0, 0, 0,  1, 0, 0, 0,  0, 1, 0, 0,  0, 0, 0, 1   ; accent counter

gkpolivoks_sn_flanger[] fillarray 0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 1, 0,  0, 1, 0, 0   ; elastic backbeat
gkpolivoks_sn_solid[] fillarray 0, 0, 0, 1,  0, 0, 1, 0,  0, 0, 0, 1,  0, 0, 0, 1   ; syncopated tail

gkpolivoks_hh_analog[]  fillarray 1, 0, 1, 0,  1, 0, 1, 0,  1, 0, 1, 0,  1, 0, 1, 0   ; grid backbone
gkpolivoks_rd_analog[]  fillarray 0, 0, 0, 1,  0, 1, 0, 0,  0, 1, 0, 1,  0, 0, 0, 1   ; slight shuffle

gkpolivoks_bd_electro[]  fillarray 0, 0, 0, 1,  0, 0, 0, 0,  0, 1, 0, 0,  0, 0, 0, 0   ; rolling accent
gkpolivoks_sn_synth[]  fillarray 0, 0, 0, 0,  0, 0, 0, 1,  0, 0, 0, 0,  1, 0, 0, 0   ; fill echo


#define if_polivoks(instr'dyn)#
kdyn_$instr = gkpolivoks_$instr[kdiv%gkpolivoks_len]
if kdyn_$instr > 0 && gkpolivoks_jit1 < 7.5 then
	schedulek Sinstr, konset, \
		1, \
		kdyn_$instr*idyn/$dyn, \
		ich, \
		sprintf("%s/%s.wav", gSpolivoks_dir, "$instr"), \
		1
endif

if gkpolivoks_jit1 > 8.5 then
	kjit_onset = konset*gkbeats
	kjit_dyn = kdyn_$instr*idyn/$dyn
	kjit_pitch = random:k(.5, 1.5)
	schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
		1, \
		kjit_dyn, \
		ich, \
		sprintf("%s/%s.wav", gSpolivoks_dir, "$instr"), \
		kjit_pitch
	if gkpolivoks_jit2 > 7.5 then
		schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
			1, \
			kjit_dyn, \
			ich, \
			sprintf("%s/%s.wav", gSpolivoks_dir, "$instr"), \
			kjit_pitch
	endif
endif
#

instr polivoks
	$params(polivoks_instrument)

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
			konset = (gkbeats/4)*gkpolivoks_swing
		endif 

		$if_polivoks(hh_analog'1)
		$if_polivoks(rd_analog'1)

		$if_polivoks(bd_analog1'1)
		$if_polivoks(bd_analog2'1)

		$if_polivoks(sn_flanger'1)
		$if_polivoks(sn_solid'1)
		$if_polivoks(bd_electro'1)
		$if_polivoks(sn_synth'1)
	endif

	if active:k("polivoks_jit") == 0 then
		schedule "polivoks_jit", 0, -idur
	endif

endin

instr polivoks_jit
	idur			abs p3
	gkpolivoks_jit1 	abs jitter(9, gkbeatf/8, gkbeatf)
	gkpolivoks_jit2 	abs jitter(9, gkbeatf/8, gkbeatf)
	if timeinsts() > idur+3.5 then
		turnoff
	endif 
endin

instr polivoks_instrument
	Sinstr 		init "polivoks"
	idyn 		init p4
	ich			init p5
	Spath 		init p6
	ipitch 		init p7

	ilen 		filelen Spath
	ionset		i gkpolivoks_onset
	idur_ratio	i gkpolivoks_dur
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

