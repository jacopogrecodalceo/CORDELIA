	instr piano_load

ipiano   sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/piano.sf2"
	sfpassign 0, ipiano
	turnoff

	endin
	schedule "piano_load", 0, 1

	$START_INSTR(piano)

aout		sfplay3m 1, ftom:i(A4), $dyn_var/2048, icps, 0, 1
	
	$dur_var(10)
	$END_INSTR
