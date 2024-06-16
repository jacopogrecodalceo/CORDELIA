; N.B. Path without the last slash / !!!
gScello_pizz_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-cello_pizz"

$start_instr(cello_pizz)

	; NO SAMPLE FOR DYN

    inote = 69 + 12 * log2(icps / A4)

	; IF IN RANGE:
		if inote <= 54 && inote > 0 then
				irootnote = 48
				Snote_name init "C3"
		elseif inote <= 61 && inote > 54 then
				irootnote = 55
				Snote_name init "G3"
		elseif inote <= 127 && inote > 61 then
				irootnote = 69
				Snote_name init "A4"
		endif

	;/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-cello_pizz/CelloPizz1_A4-4.wav
	;/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samp-cello_pizz/CelloPizz1_A4-4.wav
	irootnote2cps = A4 * pow(2, (irootnote - 69) / 12)
	iratio = icps / irootnote2cps
	;/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samp-cello_pizz/CelloPizz1_A4-1.wav
	Spath sprintf "%s/CelloPizz1_%s-%i.wav", gScello_pizz_path, Snote_name, int(random:i(1, 5))

	aouts[] diskin Spath, iratio

	aout = aouts[ich-1]
	idyn_base = .5
	idyn_scaled = idyn_base + idyn * (1 - idyn_base)
	aout moogladder2 aout*idyn_scaled, limit(15$k-((1-idyn)*7.5$k)+icps*idyn, 50, 15$k), random:i(0, 1/9)
	$dur_var(10)
$end_instr
