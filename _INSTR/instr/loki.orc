; N.B. Path without the last slash / !!!
gSloki_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-loki"
giloki_mecha	init 1

	$start_instr(loki)
	; IF RANGE DYN
		if      idyn < ampdbfs(-13) then
			Sdyn init "0-30"
		elseif  idyn < ampdbfs(-11) then
			idyn init ampdbfs(-11)
			Sdyn init "31-60"
		elseif  idyn < ampdbfs(-9) then
			idyn init ampdbfs(-9)
			Sdyn init "61-90"
		elseif	idyn < ampdbfs(-5) then
			idyn init ampdbfs(-5)
			Sdyn init "91-110"
		else
			Sdyn init "111-127"
		endif


	inote = 69 + 12 * log2(icps / A4)
	; IF IN RANGE:
		if inote <= 11 && inote > 0 then
				irootnote = 9
				Snote_name init "A-1"
		elseif inote <= 14 && inote > 11 then
				irootnote = 12
				Snote_name init "C0"
		elseif inote <= 17 && inote > 14 then
				irootnote = 15
				Snote_name init "Eb0"
		elseif inote <= 20 && inote > 17 then
				irootnote = 18
				Snote_name init "Gb0"
		elseif inote <= 23 && inote > 20 then
				irootnote = 21
				Snote_name init "A0"
		elseif inote <= 26 && inote > 23 then
				irootnote = 24
				Snote_name init "C1"
		elseif inote <= 29 && inote > 26 then
				irootnote = 27
				Snote_name init "Eb1"
		elseif inote <= 32 && inote > 29 then
				irootnote = 30
				Snote_name init "Gb1"
		elseif inote <= 35 && inote > 32 then
				irootnote = 33
				Snote_name init "A1"
		elseif inote <= 38 && inote > 35 then
				irootnote = 36
				Snote_name init "C2"
		elseif inote <= 41 && inote > 38 then
				irootnote = 39
				Snote_name init "Eb2"
		elseif inote <= 44 && inote > 41 then
				irootnote = 42
				Snote_name init "Gb2"
		elseif inote <= 47 && inote > 44 then
				irootnote = 45
				Snote_name init "A2"
		elseif inote <= 50 && inote > 47 then
				irootnote = 48
				Snote_name init "C3"
		elseif inote <= 53 && inote > 50 then
				irootnote = 51
				Snote_name init "Eb3"
		elseif inote <= 56 && inote > 53 then
				irootnote = 54
				Snote_name init "Gb3"
		elseif inote <= 59 && inote > 56 then
				irootnote = 57
				Snote_name init "A3"
		elseif inote <= 62 && inote > 59 then
				irootnote = 60
				Snote_name init "C4"
		elseif inote <= 65 && inote > 62 then
				irootnote = 63
				Snote_name init "Eb4"
		elseif inote <= 68 && inote > 65 then
				irootnote = 66
				Snote_name init "Gb4"
		elseif inote <= 71 && inote > 68 then
				irootnote = 69
				Snote_name init "A4"
		elseif inote <= 74 && inote > 71 then
				irootnote = 72
				Snote_name init "C5"
		elseif inote <= 77 && inote > 74 then
				irootnote = 75
				Snote_name init "Eb5"
		elseif inote <= 80 && inote > 77 then
				irootnote = 78
				Snote_name init "Gb5"
		elseif inote <= 83 && inote > 80 then
				irootnote = 81
				Snote_name init "A5"
		elseif inote <= 86 && inote > 83 then
				irootnote = 84
				Snote_name init "C6"
		elseif inote <= 89 && inote > 86 then
				irootnote = 87
				Snote_name init "Eb6"
		elseif inote <= 92 && inote > 89 then
				irootnote = 90
				Snote_name init "Gb6"
		elseif inote <= 127 && inote > 92 then
				irootnote = 96
				Snote_name init "C7"
		endif

	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps


	if (ich % 2) == 0 then
		Smics_lateral[]	fillarray "L", "LKey"
	else
		Smics_lateral[]	fillarray "R", "RKey"
	endif

	imax_RR			init 5
	if strcmp(Snote_name, "A2") == 0 then
		imax_RR	init 4
	elseif strcmp(Snote_name, "Eb3") == 0 then
		imax_RR	init 4
	elseif strcmp(Snote_name, "Gb2") == 0 then
		imax_RR	init 4
	elseif strcmp(Snote_name, "Gb1") == 0 then
		imax_RR	init 4
	elseif strcmp(Snote_name, "A3") == 0 then
		imax_RR	init 4
	elseif strcmp(Snote_name, "C4") == 0 then
		imax_RR	init 4
	endif

	index_RR_lateral		init 1 + (floor(icps*idyn) % (imax_RR))

	S_RR_lateral			sprintf "RR%i", index_RR_lateral
	Spath_lateral			sprintf "%s/FP_%s_%s_%s_%s.wav", gSloki_path, Smics_lateral[(floor(icps) % 2)], Snote_name, Sdyn, S_RR_lateral
	aout_lateral			diskin Spath_lateral, iratio;, iskiptime/1000



	;index_RR_central		init 1 + (floor(icps*idyn*2) % (imax_RR))

	;S_RR_central			sprintf "RR%i", index_RR_central
	S_RR_central			sprintf "RR%i", floor(random(1, imax_RR))
	Spath_central			sprintf "%s/FP_%s_%s_%s_%s.wav", gSloki_path, "C", Snote_name, Sdyn, S_RR_central
	aout_central			diskin Spath_central, iratio;, iskiptime/1000
	aout					sum aout_lateral/8, aout_central/8
	;prints sprintf("%s\n", Spath_lateral)
	;FP_RKey_C4_31-60_RR1
	; RELEASE
	;================================================================
	if idur < 7.5 then
		Spath_release sprintf "%s/KeyNoise_RR%i.wav", gSloki_path, floor(index_RR_lateral / imax_RR)*15
		schedule "loki_release", 0, 5, Spath_release, idyn/3, ich
	endif

	index_RR_release		init 1 + (floor(icps*idyn) % 20)


	if  idyn < ampdbfs(-7) then
		Spath_release sprintf "%s/release_soft_RR%i.wav", gSloki_path, index_RR_release
	else
		Spath_release sprintf "%s/release_hard_RR%i.wav", gSloki_path, index_RR_release
	endif
	schedule "loki_release", idur, idur, Spath_release, idyn*giloki_mecha, ich
	;================================================================

	ifactor_dyn init 4
	$dur_var(10)
$end_instr


instr loki_release

	Sinstr 	init "loki"
	Spath init p4
	ilen filelen Spath
	if p3 > ilen then
		p3 init ilen
	endif
	idur init p3
	idyn init p5
	ich init p6
	aenv cosseg 0, .05, 1, idur-.05*2, 1, .05, 0
	ains[] diskin Spath, 1;, iskiptime/1000
	ifactor_dyn init 1
	$sample_instr_out
	aout = ain
	$channel_mix
endin

