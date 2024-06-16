; N.B. Path without the last slash / !!!
gSechor2_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-echorda2"

$start_instr(echor2)

	; NO SAMPLE FOR DYN

    inote = 69 + 12 * log2(icps / A4)

	; IF IN RANGE:
	if inote <= 11 && inote > 0 then
			irootnote = 9
			Snote_name init "A-1"
	elseif inote <= 13 && inote > 11 then
			irootnote = 12
			Snote_name init "C0"
	elseif inote <= 15 && inote > 13 then
			irootnote = 14
			Snote_name init "D0"
	elseif inote <= 18 && inote > 15 then
			irootnote = 16
			Snote_name init "E0"
	elseif inote <= 20 && inote > 18 then
			irootnote = 19
			Snote_name init "G0"
	elseif inote <= 23 && inote > 20 then
			irootnote = 21
			Snote_name init "A0"
	elseif inote <= 25 && inote > 23 then
			irootnote = 24
			Snote_name init "C1"
	elseif inote <= 27 && inote > 25 then
			irootnote = 26
			Snote_name init "D1"
	elseif inote <= 30 && inote > 27 then
			irootnote = 28
			Snote_name init "E1"
	elseif inote <= 32 && inote > 30 then
			irootnote = 31
			Snote_name init "G1"
	elseif inote <= 35 && inote > 32 then
			irootnote = 33
			Snote_name init "A1"
	elseif inote <= 42 && inote > 35 then
			irootnote = 36
			Snote_name init "C2"
	elseif inote <= 56 && inote > 42 then
			irootnote = 43
			Snote_name init "G2"
	elseif inote <= 59 && inote > 56 then
			irootnote = 57
			Snote_name init "A3"
	elseif inote <= 61 && inote > 59 then
			irootnote = 60
			Snote_name init "C4"
	elseif inote <= 63 && inote > 61 then
			irootnote = 62
			Snote_name init "D4"
	elseif inote <= 66 && inote > 63 then
			irootnote = 64
			Snote_name init "E4"
	elseif inote <= 68 && inote > 66 then
			irootnote = 67
			Snote_name init "G4"
	elseif inote <= 71 && inote > 68 then
			irootnote = 69
			Snote_name init "A4"
	elseif inote <= 127 && inote > 71 then
			irootnote = 108
			Snote_name init "C8"
	endif

	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	;ECHORDA2_31_G1
	Spath sprintf "%s/ECHORDA2_%i_%s.wav", gSechor2_path, irootnote, Snote_name

	iskiptime random 300, 350
	aouts[] diskin Spath, iratio, iskiptime/1000*(1-idyn)

	aout = aouts[ich-1]
	idyn_base = .5
	idyn_scaled = idyn_base + idyn * (1 - idyn_base)
	aout moogladder2 aout*idyn_scaled, limit(15$k-((1-idyn)*14.5$k)+icps*idyn, 50, 15$k), random:i(0, 1/9)
	$dur_var(10)
$end_instr
