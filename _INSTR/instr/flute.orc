	instr flute_load
isf	sfload "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/soundfonts/flute.sf2"
	sfpassign 1, isf
	endin
	schedule "flute_load", 0, 0

	$start_instr(flute)
	$cps_hi_limit(ntof("8C"))

ipreindex	init 2
iflag		init 1
aout		sfplay3m 1, ftom:i(A4), $dyn_var/4096, icps, ipreindex, iflag
	
	$dur_var(10)
	$end_instr
