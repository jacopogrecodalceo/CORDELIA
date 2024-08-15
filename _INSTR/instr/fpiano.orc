; N.B. Path without the last slash / !!!
gSfpiano_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-kawai_felt"

massign 0, "fpiano"


$start_instr(fpiano)

	; IF RANGE DYN
		if 			idyn < ampdbfs(-23) then
			Sdyn init "p"
		elseif		idyn < ampdbfs(-11) then
			Sdyn init "m"
		else
			Sdyn init "f"
		endif

    inote = 69 + 12 * log2(icps / A4)

	; IF IN RANGE:
		if inote <= 17 && inote > 0 then
			irootnote = 11
			Snote_name init "B-1"
		elseif inote <= 22 && inote > 17 then
			irootnote = 18
			Snote_name init "F#0"
		elseif inote <= 25 && inote > 22 then
			irootnote = 23
			Snote_name init "B0"
		elseif inote <= 29 && inote > 25 then
			irootnote = 26
			Snote_name init "D1"
		elseif inote <= 34 && inote > 29 then
			irootnote = 30
			Snote_name init "F#1"
		elseif inote <= 37 && inote > 34 then
			irootnote = 35
			Snote_name init "B1"
		elseif inote <= 41 && inote > 37 then
			irootnote = 38
			Snote_name init "D2"
		elseif inote <= 46 && inote > 41 then
			irootnote = 42
			Snote_name init "F#2"
		elseif inote <= 49 && inote > 46 then
			irootnote = 47
			Snote_name init "B2"
		elseif inote <= 53 && inote > 49 then
			irootnote = 50
			Snote_name init "D3"
		elseif inote <= 58 && inote > 53 then
			irootnote = 54
			Snote_name init "F#3"
		elseif inote <= 61 && inote > 58 then
			irootnote = 59
			Snote_name init "B3"
		elseif inote <= 65 && inote > 61 then
			irootnote = 62
			Snote_name init "D4"
		elseif inote <= 70 && inote > 65 then
			irootnote = 66
			Snote_name init "F#4"
		elseif inote <= 73 && inote > 70 then
			irootnote = 71
			Snote_name init "B4"
		elseif inote <= 77 && inote > 73 then
			irootnote = 74
			Snote_name init "D5"
		elseif inote <= 85 && inote > 77 then
			irootnote = 78
			Snote_name init "F#5"
		elseif inote <= 127 && inote > 85 then
			irootnote = 93
			Snote_name init "A6"
		endif

	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	;Felt Piano m A6 RR1.wav
	;Felt Piano Release D5.wav
	Spath sprintf "%s/Felt_Piano_%s_%s_RR%i.wav", gSfpiano_path, Sdyn, Snote_name, int(random:i(1, 3))

	; RELEASE
	;================================================================
	Spath_release sprintf "%s/Felt_Piano_Release_%s.wav", gSfpiano_path, Snote_name
	schedule "fpiano_release", random:i(.125, .135), idur*2, Spath_release, idyn, ich
	;================================================================

	iskiptime random 1490, 1497
	aouts[] diskin Spath, iratio, iskiptime/1000

	aout = aouts[ich-1]*$dyn_var*12

	$dur_var(10)
$end_instr

instr fpiano_release
	Sinstr init "fpiano"
	Spath init p4
	ilen filelen Spath
	if p3 > ilen then
		p3 init ilen
	endif
	idur init p3
	idyn init p5
	ich init p6
	aenv cosseg idyn, p3-.005, idyn, .005, 0
	iskiptime random 1480, 1495
	aouts[] diskin Spath, 1, iskiptime/1000
	aout = aouts[ich-1]*aenv
	$channel_mix
endin
