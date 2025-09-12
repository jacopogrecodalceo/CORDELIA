	$start_instr(in2)
ain	inch 2
aout	butterhp ain, 20
aout	butterhp aout, 95
aout	butterhp aout, 135
aout	*= idyn

	$dur_var(25)
	$end_instr
	
	
/* indx	init 1
until	indx > ginchnls do
	schedule  nstrnum("in1")+((indx+1)/1000), 0, -1, 0, 0, 0, indx
	indx += 1
od
 */