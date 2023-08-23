		$start_instr(repuck)

ipanfreq	init random:i(-.25, .25)

aout	repluck random:i(.015, .35), $dyn_var, icps + random:i(-ipanfreq, ipanfreq), randomh:k(.25, .95, random:i(.05, .15)), random:i(.05, .65), poscil(1, random:i(.05, .25),  gisine)
aout	dcblock2 aout

aout	buthp aout, icps - icps/12

		$dur_var(10)
		$end_instr
