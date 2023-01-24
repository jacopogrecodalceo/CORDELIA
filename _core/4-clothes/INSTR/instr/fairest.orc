gkfairest_harm init 1

	instr fairest

Sinstr		init "fairest"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ivib		init $p
kvibfreq	= randomi:k(1.5, 5, .25, 3)
iamp		-= ivib

;	a1
atri1	oscil3	1, icps + random:i(-1, 1), gitri
asin1	oscil3	1/4, icps*3 + random:i(-1, 1), gisine
asqu1	oscil3	1/12, icps/2 + random:i(-1, 1), gisquare

aharm1	oscil3	1/8, icps*6/2 + random:i(-1, 1), gisquare


aout	= atri1 + asin1 + asqu1 + (aharm1*gkfairest_harm)
aout	/= 4+gkfairest_harm

aout	distort aout, expseg:k(random:i(.85, .15), idur, .05), gitri
aout	moogladder aout, icps + expseg:k(icps*8 + random:i(-15, 15), idur, 0.05), expseg:k(.5, idur*9/10, random:i(.895, .65), idur/10, .25)
aout	K35_hpf aout, 25, 7.5

aout	*= iamp + (lfo:a(ivib, kvibfreq + random:i(-.15, .15)) * expsega(.0005, idur, 1))

ienvvar		init idur/10

	$death

	endin
