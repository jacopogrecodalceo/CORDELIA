gisakata_len					init 16
gSsakata_dir					init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-rhy-sakata"

gksakata_jit1	init 0
gksakata_jit2	init 0
gksakata_swing	init 0
gksakata_dur	init 1
gksakata_onset	init 0

gksakata_bass1[]            fillarray 1, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 1, 0, 	0, 0, 0, 0
gksakata_bass2[]            fillarray 0, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 0, 0
gksakata_bass3[]            fillarray 0, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 0, 0

gksakata_snare1[]           fillarray 0, 0, 0, 0, 	1, 0, 0, 0, 	0, 0, 0, 0, 	1, 0, 0, 0
gksakata_snare2[]           fillarray 0, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 0,0
gksakata_snare3[]           fillarray 0, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 0, 0

gksakata_accenthh[]         fillarray 0, 0, 0, 1, 	0, 0, 0, 0, 	0, 0, 0, 0, 	0, 0, 0, 0
gksakata_openhh[]           fillarray 0, 0, 0, 0, 	1, 0, 0, 0, 	1, 0, 0, 0, 	1, 0, 0, 0
gksakata_closedhh[]         fillarray 1, 1, 1, 1, 	0, 1, 1, 1,		0, 1, 1, 1,		0, 1, 1, 1

gksakata_ride1[]            fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

gksakata_agogo1[]           fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
gksakata_agogo2[]           fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

gksakata_tom1[]             fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
gksakata_tom2[]             fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
gksakata_tom3[]             fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

gksakata_rim[]              fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   ; rim pattern
gksakata_tom4[]             fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   ; tom4 pattern
gksakata_clap[]             fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   ; clap pattern
gksakata_ride2[]            fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   ; ride2 pattern
gksakata_crash[]            fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   ; crash pattern
gksakata_cabasa2[]          fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   ; cabasa2 pattern
gksakata_cabasa1[]          fillarray 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   ; cabasa1 pattern



#define if_sakata(instr'dyn)#
ilen_$instr		lenarray gksakata_$instr
klen_$instr		= ilen_$instr
kdiv			= floor(((kcycle*idiv)%1)*klen_$instr)
if changed2(kdiv) == 1 then
	if kdiv % idiv*2 == 0 then
		konset = 0
	else
		konset = (gkbeats/4)*gksakata_swing
	endif 

	kdyn_$instr = gksakata_$instr[kdiv%klen_$instr]

	;kdyn_$instr = gksakata_$instr[kdiv%gisakata_len]
	if kdyn_$instr > 0 && gksakata_jit1 < 7.5 then
		schedulek Sinstr, konset, \
			1, \
			kdyn_$instr*idyn/$dyn, \
			ich, \
			sprintf("%s/%s.wav", gSsakata_dir, "$instr"), \
			1
	endif

	if gksakata_jit1 > 8.5 then
		kjit_onset = konset*gkbeats
		kjit_dyn = kdyn_$instr*idyn/$dyn
		kjit_pitch = random:k(.5, 1.5)
		schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
			1, \
			kjit_dyn, \
			ich, \
			sprintf("%s/%s.wav", gSsakata_dir, "$instr"), \
			kjit_pitch
		if gksakata_jit2 > 7.5 then
			schedulek Sinstr, kjit_onset*floor(random:i(1, 4)), \
				1, \
				kjit_dyn, \
				ich, \
				sprintf("%s/%s.wav", gSsakata_dir, "$instr"), \
				kjit_pitch
		endif
	endif
endif
#

instr sakata
	$params(sakata_instrument)

	idiv			init icps

	; divide the main 64 quarter notes into a subdivision of 8 quarter notes
	; so from 0 to 1 now the cycle is from 0 to (64 / 8) = 8
	; representing the 8 bars
	kcycle			= chnget:k("heart")*gkdiv
	$if_sakata(agogo1'1)
	$if_sakata(accenthh'8)
	$if_sakata(agogo2'1)
	$if_sakata(tom1'1)
	$if_sakata(tom2'1)
	$if_sakata(tom3'1)
	$if_sakata(bass1'1)
	$if_sakata(rim'1)
	$if_sakata(tom4'1)
	$if_sakata(bass2'1)
	$if_sakata(bass3'1)
	$if_sakata(closedhh'8)
	$if_sakata(openhh'8)
	$if_sakata(clap'1)
	$if_sakata(ride2'1)
	$if_sakata(snare1'1)
	$if_sakata(crash'1)
	$if_sakata(cabasa2'1)
	$if_sakata(ride1'1)
	$if_sakata(snare2'1)
	$if_sakata(snare3'1)
	$if_sakata(cabasa1'1)

	if active:k("sakata_jit") == 0 then
		schedule "sakata_jit", 0, -idur
	endif

endin

instr sakata_jit
	idur			abs p3
	gksakata_jit1 	abs jitter(9, gkbeatf/8, gkbeatf)
	gksakata_jit2 	abs jitter(9, gkbeatf/8, gkbeatf)
	if timeinsts() > idur+3.5 then
		turnoff
	endif 
endin

instr sakata_instrument
	Sinstr 		init "sakata"
	idyn 		init p4
	ich			init p5
	Spath 		init p6
	ipitch 		init p7

	ilen 		filelen Spath
	ionset_ratio		i gksakata_onset
	ionset				init ionset_ratio*ilen
	idur_ratio			i gksakata_dur
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

