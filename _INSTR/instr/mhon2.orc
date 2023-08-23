gkmhon2_cps	init 20
gimhon2_choose	init 1
gkmhon2_start	init 0
gkmhon2_ch	init 8

	instr mhon2
	$params(mhon2_instr)

istart		init i(gkmhon2_start)

schedule Sinstr, istart, idur, idyn, ienv, icps, ich

gimhon2_choose	= gimhon2_choose%(nchnls*i(gkmhon2_ch))

if	gimhon2_choose == 1 then
	gkmhon2_cps	= icps
	gimhon2_choose += 1 
else
	gimhon2_choose += 1 
endif

	turnoff
	endin

	

	instr mhon2_instr
	$params(mhon2)

a1		oscil3 $dyn_var, cosseg(i(gkmhon2_cps), idur/8, icps), gisquare
a2		oscil3 $dyn_var, cosseg(i(gkmhon2_cps), idur/6, icps)*3/2*1.975, gitri

aout		= a1 + (a2/3)

ifact		init 16
idyn_fact	init 8
iq		init $dyn_var

amoog_freq	cosseg i(gkmhon2_cps)*(ifact)*($dyn_var*idyn_fact), idur/6, icps*ifact*($dyn_var*idyn_fact)
amoog_freq	limit amoog_freq, 25, 20$k

aq		cosseg iq, idur, iq*2
aq		limit a1, 0, .9995

aout		moogladder2 aout, amoog_freq, iq

	$dur_var(10)
	$end_instr
