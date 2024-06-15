	instr piano_load

ipiano   sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/piano.sf2"
	sfpassign 0, ipiano
	turnoff
	endin
	
	schedule "piano_load", 0, 1

	$start_instr(piano)
	$cps_hi_limit(ntof("8C"))

ipreindex	init 0
iflag		init 1

aout		sfplay3m 1, ftom:i(A4), $dyn_var/2048, icps, ipreindex, iflag
	
	$dur_var(10)
	$end_instr
