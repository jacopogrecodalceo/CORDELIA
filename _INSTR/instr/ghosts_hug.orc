
$start_instr(ghosts_hug)
	indx init 1
	imax_num init 7
	while indx < imax_num do
		idur_oscil init idur * pow(2, indx - 1) / pow(2, 3)
		idyn_oscil init (idyn / 8 / indx) / pow(2, indx - 1)
		schedule "ghosts_hug_instr", idur_oscil+random:i(-.05, .05), (idur/imax_num/2)*random:i(.95, 1.05), idyn_oscil, int(ienv)*(-1), icps*indx, ich
		indx += 1
	od
	turnoff
endin

instr ghosts_hug_instr
	$params(ghosts_hug)
	p3 init p3+2
	aoscil oscili idyn, cosseg(icps, idur*10/11, icps, idur/11, icps*random:i(.995, .975))

	aoscil *= .75+lfo:a(.25, random:i(2.5, 3.5)*cosseg(1, idur, .65))*cosseg:a(0, idur, 1)

	$dur_var(10)
	aoscil *= envgen(idur_var, ienv)
	arev nreverb aoscil, 1, random:i(.35, .85)
	aout = aoscil + arev/3
	$channel_mix
$end_instr
