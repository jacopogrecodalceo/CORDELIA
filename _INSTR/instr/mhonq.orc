gkmhonq_cps	init 20
gimhonq_choose	init 0
gkmhonq_start	init 0
gkmhonq_port	init 1

	instr mhonq
	$params(mhonq_instr)

istart		init i(gkmhonq_start)

if	istart!=0 then
	istart random 0, i(gkmhonq_start)
endif

schedule Sinstr, istart,  idur, idyn, ienv, icps, ich

if	gimhonq_choose == 1 then
	gkmhonq_cps	= icps
	gimhonq_choose init 0
else
	gimhonq_choose init 1 
endif

	turnoff
	endin

	

	instr mhonq_instr
	$params(mhonq)

iport		init i(gkmhonq_port)

a1		oscil3 $dyn_var, cosseg(i(gkmhonq_cps), (idur/8)*iport, icps), gisaw
a2		oscil3 $dyn_var, cosseg(i(gkmhonq_cps), (idur/6)*iport, icps)*3/2, gitri

aout		= a1 + (a2/4)

ifact		init 24
idyn_fact	init 8
iq		init $dyn_var

amoog_freq	cosseg i(gkmhonq_cps)*(ifact+2)*($dyn_var*idyn_fact), idur/2, icps*ifact*($dyn_var*(idyn_fact/6))
amoog_freq	limit amoog_freq, 25, 20$k

aq		cosseg iq, idur, iq*2
aq		limit a1, 0, .9995

aout		moogladder2 aout, amoog_freq, aq

	$dur_var(10)
	$end_instr
