gkfim_detune	init 1.95
gkfim_var	init 1

	instr fim_control

gafim_var	= gkbeatf

	endin
	alwayson("fim_control")

	instr fim

	$params

afreq		= icps*oscil3(1, icps*gkfim_detune, gisaw)

as		oscil3	$ampvar, afreq+(gafim_var*gkfim_var), gisine

iff		= limit(icps-(icps/9), 20, 20$k)

aout		atonex	as, iff
aout		balance aout, as
aout		/= 4
;	ENVELOPE
ienvvar		init idur/10

		$death

	endin
