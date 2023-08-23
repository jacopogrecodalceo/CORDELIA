gkmhonrx_cps	init 20
gimhonrx_choose	init 0
gkmhonrx_start	init 0
gkmhonrx_port	init 1

	instr mhonrx
	$params(mhonrx_instr)

istart		init i(gkmhonrx_start)

if	istart!=0 then
	istart random 0, i(gkmhonrx_start)
endif

schedule Sinstr, istart, idur, idyn, ienv, icps, ich

if	gimhonrx_choose == 1 then
	gkmhonrx_cps	= icps
	gimhonrx_choose init 0
else
	gimhonrx_choose init 1 
endif

	turnoff
	endin

	

	instr mhonrx_instr
	$params(mhonrx)

iport		init i(gkmhonrx_port)

a1		oscil3 $dyn_var, cosseg(icps, (idur/8)*iport, i(gkmhonrx_cps)), gisaw
a2		oscil3 $dyn_var, cosseg(icps, (idur/6)*iport, i(gkmhonrx_cps))*3/2, gitri

aout		= a1 + (a2/4)

ifact		init 24
idyn_fact	init 8
iq			init $dyn_var

amoog_freq	cosseg i(gkmhonrx_cps)*(ifact+2)*($dyn_var*idyn_fact), idur/2, icps*ifact*($dyn_var*(idyn_fact/6))
amoog_freq	limit amoog_freq, 25, 20$k

aq			cosseg iq, idur, iq*2
aq			limit a1, 0, .9995

aout		moogladder2 aout, amoog_freq, iq

	$dur_var(10)
	$end_instr
