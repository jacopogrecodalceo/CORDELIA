gkmhonr_cps	init 20
gimhonr_choose	init 0
gkmhonr_start	init 0
gkmhonr_port	init 1

	instr mhonr
	$params(mhonr_instr)

istart		init i(gkmhonr_start)

if	istart!=0 then
	istart random 0, i(gkmhonr_start)
endif

schedule Sinstr, istart, idur, idyn, ienv, icps, ich

if	gimhonr_choose == 1 then
	gkmhonr_cps	= icps
	gimhonr_choose init 0
else
	gimhonr_choose init 1 
endif

	turnoff
	endin

	

	instr mhonr_instr
	$params(mhonr)

iport		init i(gkmhonr_port)

a1		oscil3 $dyn_var, cosseg(icps, (idur/8)*iport, i(gkmhonr_cps)), gisaw
a2		oscil3 $dyn_var, cosseg(i(gkmhonr_cps), (idur/6)*iport, icps)*3/2, gitri

aout		= a1 + (a2/4)

ifact		init 24
idyn_fact	init 8
iq			init $dyn_var

amoog_freq	cosseg i(gkmhonr_cps)*(ifact+2)*($dyn_var*idyn_fact), idur/2, icps*ifact*($dyn_var*(idyn_fact/6))
amoog_freq	limit amoog_freq, 25, 20$k

aq			cosseg iq, idur, iq*2
aq			limit a1, 0, .9995

aout		moogladder2 aout, amoog_freq, iq

	$dur_var(10)
	$end_instr
