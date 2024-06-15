; N.B. Path without the last slash / !!!
gSechor3p1_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-echorda3p1"

$start_instr(echor3p1)

	; NO SAMPLE FOR DYN

    inote = 69 + 12 * log2(icps / A4)

	; IF IN RANGE:
		if inote <= 23 && inote > 0 then
				irootnote = 21
				Snote_name init "A0"
		elseif inote <= 25 && inote > 23 then
				irootnote = 24
				Snote_name init "C1"
		elseif inote <= 27 && inote > 25 then
				irootnote = 26
				Snote_name init "D1"
		elseif inote <= 32 && inote > 27 then
				irootnote = 28
				Snote_name init "E1"
		elseif inote <= 35 && inote > 32 then
				irootnote = 33
				Snote_name init "A1"
		elseif inote <= 37 && inote > 35 then
				irootnote = 36
				Snote_name init "C2"
		elseif inote <= 39 && inote > 37 then
				irootnote = 38
				Snote_name init "D2"
		elseif inote <= 51 && inote > 39 then
				irootnote = 40
				Snote_name init "E2"
		elseif inote <= 54 && inote > 51 then
				irootnote = 52
				Snote_name init "E3"
		elseif inote <= 56 && inote > 54 then
				irootnote = 55
				Snote_name init "G3"
		elseif inote <= 59 && inote > 56 then
				irootnote = 57
				Snote_name init "A3"
		elseif inote <= 63 && inote > 59 then
				irootnote = 60
				Snote_name init "C4"
		elseif inote <= 66 && inote > 63 then
				irootnote = 64
				Snote_name init "E4"
		elseif inote <= 68 && inote > 66 then
				irootnote = 67
				Snote_name init "G4"
		elseif inote <= 71 && inote > 68 then
				irootnote = 69
				Snote_name init "A4"
		elseif inote <= 73 && inote > 71 then
				irootnote = 72
				Snote_name init "C5"
		elseif inote <= 80 && inote > 73 then
				irootnote = 74
				Snote_name init "D5"
		elseif inote <= 83 && inote > 80 then
				irootnote = 81
				Snote_name init "A5"
		elseif inote <= 127 && inote > 83 then
				irootnote = 86
				Snote_name init "D6"
		endif

	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	;ECHORDA3_P1_26_D1_03.aif
	;ECHORDA3_P1_40_E2_4
	Spath sprintf "%s/ECHORDA3_P1_%i_%s_0%i.aif", gSechor3p1_path, irootnote, Snote_name, int(random:i(1, 5))

	;iskiptime random 300, 350
	aouts[] diskin Spath, iratio;, iskiptime/1000*(1-idyn)

	aout = aouts[ich-1]
	idyn_scaled = .75 + idyn * (1 - .75)
	aout moogladder2 aout*idyn_scaled, limit(15$k-((1-idyn)*14.5$k)+icps, 50, 15$k), random:i(0, 1/9)
	aout *= 12
	$dur_var(10)
$end_instr
