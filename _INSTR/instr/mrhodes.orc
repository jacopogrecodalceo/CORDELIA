; N.B. Path without the last slash / !!!
gSmrhodes_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-mrhodes"

$start_instr(mrhodes)

	; IF RANGE DYN
		if 			idyn < ampdbfs(-17) then
			Sdyn init "p"
		else
			Sdyn init "f"
		endif

    inote = 69 + 12 * log2(icps / A4)

	; IF IN RANGE:
if inote <= 18 && inote > 0 then
        irootnote = 16
        Snote_name init "E0"
elseif inote <= 22 && inote > 18 then
        irootnote = 19
        Snote_name init "G0"
elseif inote <= 25 && inote > 22 then
        irootnote = 23
        Snote_name init "B0"
elseif inote <= 29 && inote > 25 then
        irootnote = 26
        Snote_name init "D1"
elseif inote <= 32 && inote > 29 then
        irootnote = 30
        Snote_name init "F#1"
elseif inote <= 36 && inote > 32 then
        irootnote = 33
        Snote_name init "A1"
elseif inote <= 39 && inote > 36 then
        irootnote = 37
        Snote_name init "C#2"
elseif inote <= 43 && inote > 39 then
        irootnote = 40
        Snote_name init "E2"
elseif inote <= 46 && inote > 43 then
        irootnote = 44
        Snote_name init "G#2"
elseif inote <= 50 && inote > 46 then
        irootnote = 47
        Snote_name init "B2"
elseif inote <= 53 && inote > 50 then
        irootnote = 51
        Snote_name init "D#3"
elseif inote <= 57 && inote > 53 then
        irootnote = 54
        Snote_name init "F#3"
elseif inote <= 60 && inote > 57 then
        irootnote = 58
        Snote_name init "A#3"
elseif inote <= 63 && inote > 60 then
        irootnote = 61
        Snote_name init "C#4"
elseif inote <= 64 && inote > 63 then
        irootnote = 64
        Snote_name init "E4"
elseif inote <= 67 && inote > 64 then
        irootnote = 65
        Snote_name init "F4"
elseif inote <= 71 && inote > 67 then
        irootnote = 68
        Snote_name init "G#4"
elseif inote <= 73 && inote > 71 then
        irootnote = 72
        Snote_name init "C5"
elseif inote <= 74 && inote > 73 then
        irootnote = 74
        Snote_name init "D5"
elseif inote <= 78 && inote > 74 then
        irootnote = 75
        Snote_name init "D#5"
elseif inote <= 81 && inote > 78 then
        irootnote = 79
        Snote_name init "G5"
elseif inote <= 127 && inote > 81 then
        irootnote = 87
        Snote_name init "D#6"
endif

	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	;mRhodes_V3_f_A#3.aif
	Spath sprintf "%s/mRhodes_V3_%s_%s.aif", gSmrhodes_path, Sdyn, Snote_name

	iskiptime random 340, 345
	aout diskin Spath, iratio, iskiptime/1000
        aout /= 2
	$dur_var(10)
$end_instr
