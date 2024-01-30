	$start_instr(fairest2)

ivib		= idyn/4
kvibfreq	= randomi:k(1.5, 5, .25, 3)
idyn		-= ivib

iport		init idur/50

kcps		cosseg icps/2, iport, icps, idur-(iport), icps

;	a1
atri1	oscil3	1, kcps + random:i(-1, 1), gitri
asin1	oscil3	1/4, kcps*3 + random:i(-1, 1), gisine
asqu1	oscil3	1/12, kcps/2 + random:i(-1, 1), gisquare

aharm1	oscil3	1/8, kcps*6/2 + random:i(-1, 1), gisquare

aout	= atri1 + asin1 + asqu1 + aharm1
aout	/= 4

aout	distort aout, expseg:k(random:i(.85, .15), idur, .05), gitri

icps_moog init icps*8

until icps_moog < 15$k do
	icps_moog /= 2
od

aout	moogladder aout, icps + expseg:k(icps_moog + random:i(-15, 15), idur, 0.05), expseg:k(.5, idur*9/10, random:i(.895, .65), idur/10, .25)
aout	K35_hpf aout, 25, 7.5

aout	*= idyn + (lfo:a(ivib, kvibfreq + random:i(-.15, .15)) * expsega(.0005, idur, 1))

	$dur_var(10)
	$end_instr
