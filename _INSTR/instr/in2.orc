
	$start_instr(in2)
aout	inch 2
aout	butterhp aout, 20
aout	*= idyn


	$dur_var(25)
	$end_instr
	
indx	init 1
until	indx > ginchnls do
	schedule  nstrnum("in2")+((indx+1)/1000), 0, -1, 0, 0, 0, indx
	indx += 1
od
