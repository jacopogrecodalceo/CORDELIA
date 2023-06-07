gkmhon2q_cps	init 20
gimhon2q_choose	init 1
gkmhon2q_start	init 0
gkmhon2q_ch	init 8

	instr mhon2q

Sinstr		init "mhon2q_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

istart		init i(gkmhon2q_start)

schedule Sinstr, istart, idur, idyn, ienv, icps, ich

gimhon2q_choose	= gimhon2_choose%(nchnls*i(gkmhon2_ch))

if	gimhon2q_choose == 1 then
	gkmhon2q_cps	= icps
	gimhon2q_choose += 1 
else
	gimhon2q_choose += 1 
endif

	turnoff

	endin

	instr mhon2q_instr

Sinstr		init "mhon2q"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

a1		oscil3 $dyn_var, cosseg(i(gkmhon2q_cps), idur/8, icps), gisquare
a2		oscil3 $dyn_var, cosseg(i(gkmhon2q_cps), idur/6, icps)*3/2*1.975, gitri

aout		= a1 + (a2/3)

ifact		init 16
idyn_fact	init 8
iq		init $dyn_var

amoog_freq	cosseg i(gkmhon_cps)*(ifact)*($dyn_var*idyn_fact), idur/6, icps*ifact*($dyn_var*idyn_fact)
amoog_freq	limit amoog_freq, 25, 20$k

aq		cosseg iq, idur, iq*2
aq		limit a1, 0, .9995

aout		moogladder2 aout, amoog_freq, aq

	$dur_var(10)
	$END_INSTR

