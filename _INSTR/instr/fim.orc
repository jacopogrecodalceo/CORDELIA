gkfim_detune	init 1.95
gkfim_var		init 1

	$start_instr(fim)

afreq		= icps*oscil3(1, icps*gkfim_detune, gisaw)

as			oscil3	$dyn_var, afreq+(gkbeatf*gkfim_var), gisine
iff			limit icps-(icps/9), 20, 20$k

aout		atonex	as, iff
aout		balance2 aout, as
aout		/= 4

	$dur_var(10)
	$end_instr
