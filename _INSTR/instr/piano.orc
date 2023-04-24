	instr piano_load

ipiano   sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/piano.sf2"
	sfpassign 0, ipiano
	turnoff

	endin
	schedule "piano_load", 0, 1

	instr piano
	$params

aout		sfplay3m 1, ftom:i(A4), $ampvar/2048, icps, 0, 1
ienvvar		init idur/10

	$END_INSTR
	endin
