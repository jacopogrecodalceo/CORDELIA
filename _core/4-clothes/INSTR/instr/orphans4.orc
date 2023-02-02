gkorphans4_vib init .25

	instr orphans4

Sinstr		init "orphans4"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

icpsvar		init icps/100
ift1		init gisine
ift2		init gitri

a1		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a1		*= .5 + lfo:a(.5, gkorphans4_vib)

a2		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a2		*= .5 + lfo:a(.5, gkorphans4_vib*2)

a3		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift2
a3		*= .5 + lfo:a(.5, gkorphans4_vib*3)

a3		moogladder2 a3, icps*2+(cosseg(icps, idur/2, icps*24, idur/2, icps/2)*$ampvar), .5*cosseg(.25, p3, .85)

k1     	   line           1,		p3, 0
k2         line           -5.5,		p3, 0
k3         expon           -7,		p3, -3
k4         expon           5,		p3, 9
k5         expon           1.5,		p3, 0.75*8
k6         line           25*iamp,	p3, -1*2

aosc		= a1 + a2 + a3

acheby		chebyshevpoly  aosc, 25*iamp, k1*iamp, k2, k3, k4, k5*iamp, k6
acheby		dcblock2 acheby

aout		balance2 acheby, aosc

ienvvar		init idur/5

	$END_INSTR

	endin
