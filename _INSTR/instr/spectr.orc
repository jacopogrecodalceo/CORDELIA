gispectr_len					init 16
gSspectr_dir					init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-rhy-spectr_rx12"

gkspectr_jit	init 0
gkspectr_swing	init 0
gkspectr_dur	init 1
gkspectr_onset	init 0

; Kick Drum
gispectr_bd1 ftgen 0, 0, gispectr_len, -2, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0  ; Kick patterns: On beats 1, 5, 9, 13
gispectr_bd2 ftgen 0, 0, gispectr_len, -2, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0  ; Kick patterns: On beats 1, 5, 9, 13 with variation
gispectr_bd3 ftgen 0, 0, gispectr_len, -2, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0  ; Kick patterns: On beats 1, 4, 9, 12
gispectr_patterns_bd[] fillarray gispectr_bd1, gispectr_bd2, gispectr_bd3

; Snare
gispectr_sd1 ftgen 0, 0, gispectr_len, -2, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0  ; Snare patterns: On beats 3, 7, 11, 15
gispectr_sd2 ftgen 0, 0, gispectr_len, -2, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0  ; Snare patterns with variation: On beats 3, 7, 11, 15 with an extra hit on beat 9
gispectr_patterns_sd[] fillarray gispectr_sd1, gispectr_sd2

; Low Tom
gispectr_lt1 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0  ; Low Tom patterns: On beats 7, 13
gispectr_lt2 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0  ; Low Tom patterns with variation: On beats 7, 13, with an extra hit on beat 15
gispectr_lt3 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0  ; Low Tom patterns with variation: On beats 7, 13, with an extra hit on beat 15
gispectr_patterns_lt[] fillarray gispectr_lt1, gispectr_lt2, gispectr_lt3

; Mid Tom
gispectr_mt1 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0  ; Mid Tom patterns: On beats 6, 12
gispectr_mt2 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0  ; Mid Tom patterns with variation: On beats 6, 12, with an extra hit on beat 8
gispectr_mt3 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0  ; Mid Tom patterns with variation: On beats 6, 12, with an extra hit on beat 8
gispectr_patterns_mt[] fillarray gispectr_mt1, gispectr_mt2, gispectr_mt3

; High Tom
gispectr_ht1 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0  ; High Tom patterns: On beats 4, 10
gispectr_ht2 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0  ; High Tom patterns with variation: On beats 4, 10, with an extra hit on beat 8
gispectr_ht3 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1  ; High Tom patterns with variation: On beats 4, 10, with an extra hit on beat 8
gispectr_patterns_ht[] fillarray gispectr_ht1, gispectr_ht2, gispectr_ht3

; Rimshot
gispectr_rs1 ftgen 0, 0, gispectr_len, -2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  ; Rimshot patterns: On beats 2, 6, 10, 14
gispectr_rs2 ftgen 0, 0, gispectr_len, -2, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0  ; Rimshot patterns with variation: On beats 2, 6, 10, 14 with an extra hit on beat 8
gispectr_patterns_rs[] fillarray gispectr_rs1, gispectr_rs2

; Hand Clap
gispectr_hc1 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0  ; Hand Clap patterns: On beats 5, 13
gispectr_hc2 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0  ; Hand Clap patterns with variation: On beats 5, 13 with an extra hit on beat 9
gispectr_patterns_hc[] fillarray gispectr_hc1, gispectr_hc2

; Cowbell
gispectr_cb1 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1  ; Cowbell patterns: On beats 4, 8, 12, 16
gispectr_cb2 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0  ; Cowbell patterns with variation: On beats 4, 8, 12, 16 with an extra hit on beat 15
gispectr_patterns_cb[] fillarray gispectr_cb1, gispectr_cb2

; Crash Cymbal
gispectr_cc1 ftgen 0, 0, gispectr_len, -2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  ; Crash Cymbal patterns: On beat 1
gispectr_cc2 ftgen 0, 0, gispectr_len, -2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0  ; Crash Cymbal patterns with variation: On beat 1 and an additional hit on beat 15
gispectr_patterns_cc[] fillarray gispectr_cc1, gispectr_cc2

; Ride Cymbal
gispectr_rc1 ftgen 0, 0, gispectr_len, -2, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0  ; Ride Cymbal patterns: On beats 3, 7, 11, 15
gispectr_rc2 ftgen 0, 0, gispectr_len, -2, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  ; Ride Cymbal patterns with variation: On beats 3, 7, 11, 15 with an extra hit on beat 13
gispectr_patterns_rc[] fillarray gispectr_rc1, gispectr_rc2

; Closed Hi-Hat
gispectr_ch1 ftgen 0, 0, gispectr_len, -2, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0  ; Closed Hi-Hat patterns: On all odd beats
gispectr_ch2 ftgen 0, 0, gispectr_len, -2, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1  ; Closed Hi-Hat patterns with variation: On all odd beats, with an extra hit on beat 16
gispectr_patterns_ch[] fillarray gispectr_ch1, gispectr_ch2

; Open Hi-Hat
gispectr_oh1 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0  ; Open Hi-Hat patterns: On beats 4, 12
gispectr_oh2 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0  ; Open Hi-Hat patterns with variation: On beats 4, 12 with an extra hit on beat 8
gispectr_patterns_oh[] fillarray gispectr_oh1, gispectr_oh2

; Claves
gispectr_cl1 ftgen 0, 0, gispectr_len, -2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  ; Claves patterns: On beats 2, 6, 10, 14
gispectr_cl2 ftgen 0, 0, gispectr_len, -2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0  ; Claves patterns with variation: On beats 2, 6, 10, 14 with an extra hit on beat 12
gispectr_patterns_cl[] fillarray gispectr_cl1, gispectr_cl2

; Maracas
gispectr_ma1 ftgen 0, 0, gispectr_len, -2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1  ; Maracas patterns: On all beats
gispectr_ma2 ftgen 0, 0, gispectr_len, -2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1  ; Maracas patterns with variation: On all beats with a slight change at beat 16
gispectr_patterns_ma[] fillarray gispectr_ma1, gispectr_ma2

; Low Conga
gispectr_lc1 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0  ; Low Conga patterns: On beat 9
gispectr_lc2 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0  ; Low Conga patterns with variation: On beat 9 with an extra hit on beat 17
gispectr_patterns_lc[] fillarray gispectr_lc1, gispectr_lc2

; High Conga
gispectr_hc1 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0  ; High Conga patterns: On beats 4, 12
gispectr_hc2 ftgen 0, 0, gispectr_len, -2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0  ; High Conga patterns with variation: On beats 4, 12 with an extra hit on beat 8
gispectr_patterns_hc[] fillarray gispectr_hc1, gispectr_hc2

; Tambourine
gispectr_tb1 ftgen 0, 0, gispectr_len, -2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0  ; Tambourine patterns: On beats 2, 6, 10, 14
gispectr_tb2 ftgen 0, 0, gispectr_len, -2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0  ; Tambourine patterns with variation: On beats 2, 6, 10, 14 with an extra hit on beat 12
gispectr_patterns_tb[] fillarray gispectr_tb1, gispectr_tb2

#define if_spectr(instr'dyn)#
kdyn_$instr tablekt kdiv%gispectr_len, gispectr_patterns_$instr[kcycle%lenarray(gispectr_patterns_$instr)]
if kdyn_$instr > 0 then
	schedulek "spectr_instrument", konset, \
		1, \
		kdyn_$instr*idyn/$dyn, \
		ich, \
		sprintf("%s/%s.wav", gSspectr_dir, "$instr"), \
		1
endif
if gkspectr_jit > 8.5 then
	schedulek "spectr_instrument", konset*gkbeats*floor(random:i(1, 4)), \
		1, \
		kdyn_$instr*idyn/$dyn, \
		ich, \
		sprintf("%s/%s.wav", gSspectr_dir, "$instr"), \
		random:i(.5, 1.5)
endif
#

$start_instr(spectr)

	idiv			init icps%gispectr_len

	; divide the main 64 quarter notes into a subdivision of 8 quarter notes
	; so from 0 to 1 now the cycle is from 0 to (64 / 8) = 8
	; representing the 8 bars
	kcycle			floor chnget:k("heart")*(gkdiv/gispectr_len)*idiv
	kdiv			floor chnget:k("heart")*gkdiv*idiv
	if changed2(kdiv) == 1 then
		if kdiv % idiv*2 == 0 then
			konset = 0
		else
			konset = (gkbeats/4)*gkspectr_swing
		endif 
		$if_spectr(bd'1)
		$if_spectr(cc'1)
		$if_spectr(ch'1)
		$if_spectr(hc'1)
		$if_spectr(ht'1)
		$if_spectr(lt'1)
		$if_spectr(mt'1)
		$if_spectr(rs'1)
		$if_spectr(sd'1)
	endif

	if active:k("spectr_jit") == 0 then
		schedule "spectr_jit", 0, -idur
	endif

endin

instr spectr_jit
	idur			abs p3
	gkspectr_jit 	abs jitter(9, gkbeatf/8, gkbeatf)
	if timeinsts() > idur+3.5 then
		turnoff
	endif 
endin

instr spectr_instrument
	Sinstr 		init "spectr"
	idyn 		init p4
	ich			init p5
	Spath 		init p6
	ipitch 		init p7

	ilen 		filelen Spath
	ionset_ratio		i gkspectr_onset
	ionset		init ionset_ratio*ilen
	idur_ratio			i gkspectr_dur
	p3 			init ilen*idur_ratio
	idur 		init p3

	if idur < .005 then
		turnoff
	endif

	if idur+ionset > ilen then
		ipitch *= -1
		p3 init p3/2
	endif

	if random:i(0, 16) > 15 then
		idur /= floor(random:i(2, 8))
	endif

	aout		diskin Spath, ipitch+random:i(-.05, .05), ionset
	aout		*= cosseg:a(1, idur-.005, 1, .005, 0)*idyn
	$channel_mix
endin

