; N.B. Path without the last slash / !!!
gSkali_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-kali"

$start_instr(kali)

	; IF RANGE DYN
	if idyn < ampdbfs(-11) then
		Sdyn init "Pluck"
	else
		Sdyn init "Nail"
	endif

	inote = 69 + 12 * log2(icps / A4)

	; IF IN RANGE:
		if inote <= 47 && inote > 0 then
			irootnote = 47
			Snote_name init "B2"
		elseif inote <= 49 && inote > 47 then
			irootnote = 48
			Snote_name init "C3"
		elseif inote <= 51 && inote > 49 then
			irootnote = 50
			Snote_name init "D3"
		elseif inote <= 53 && inote > 51 then
			irootnote = 52
			Snote_name init "E3"
		elseif inote <= 54 && inote > 53 then
			irootnote = 54
			Snote_name init "F#3"
		elseif inote <= 56 && inote > 54 then
			irootnote = 55
			Snote_name init "G3"
		elseif inote <= 58 && inote > 56 then
			irootnote = 57
			Snote_name init "A3"
		elseif inote <= 59 && inote > 58 then
			irootnote = 59
			Snote_name init "B3"
		elseif inote <= 61 && inote > 59 then
			irootnote = 60
			Snote_name init "C4"
		elseif inote <= 63 && inote > 61 then
			irootnote = 62
			Snote_name init "D4"
		elseif inote <= 65 && inote > 63 then
			irootnote = 64
			Snote_name init "E4"
		elseif inote <= 66 && inote > 65 then
			irootnote = 66
			Snote_name init "F#4"
		elseif inote <= 68 && inote > 66 then
			irootnote = 67
			Snote_name init "G4"
		elseif inote <= 70 && inote > 68 then
			irootnote = 69
			Snote_name init "A4"
		elseif inote <= 71 && inote > 70 then
			irootnote = 71
			Snote_name init "B4"
		elseif inote <= 127 && inote > 71 then
			irootnote = 74
			Snote_name init "D5"
		endif
	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	;Celeste_Kalimba_Nail_B2-RR3
	Spath sprintf "%s/Celeste_Kalimba_%s_%s-RR%i.wav", gSkali_path, Sdyn, Snote_name, int(random:i(1, 4))

	aout diskin Spath, iratio

	aout *= idyn

	$dur_var(10)
$end_instr
