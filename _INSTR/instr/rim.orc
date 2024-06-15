	instr rim

Sinstr		init "rim"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

icps_init = 200

icps	=  icps_init*exp(log(2.0)*(57.0-69.0)/12.0)
acps	expon icps, .0025, icps * .5
acps	=  acps + icps

idyn	=  .095

a1a	phasor acps, .0	/* square wave */
a1b	phasor acps, .5

afmenv	expon 1, .02, .5	/* FM envelope */

a1	=  (a1a-a1b)*7*afmenv
acps	=  acps*(1+a1)

a0	oscil3 1, acps, gisine	/* sine oscillator */

a1	unirand 2		/* add some noise */
a1	tone a1-1, 2000
a0	=  a0 + a1*.1

aenv	expon 1, .005, .5	/* amp. envelope */

/* distortion */

a0	limit 4*idyn*a0*aenv, -1, 1
a0	table3 a0, gisine, 1, 0, 1

/* lowpass filter freq. envelope */

kffrq	expseg 20000, .07, 100, 1, 100

a0x	tone a0, 4000
a0y	=  a0 - a0x
a0x	delay a0y, 0.0002
aout	=  a0 - a0x*4
aout	pareq aout, kffrq, 0, 0.7071, 2

/* de-click envelope */

aout	=  aout*linseg(1, p3-0.1, 1, 0.025, 0, 1, 0)

$dur_var(25)

	$end_instr

	
