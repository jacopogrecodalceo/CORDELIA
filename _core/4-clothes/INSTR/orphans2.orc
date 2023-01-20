	instr orphans2_control

gkorphans2_var lfse 50, 100, gkbeatf/64

	endin
	schedule("orphans2_control", 0, -1)

	instr orphans2

Sinstr		init "orphans2"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

icpsvar		init icps/i(gkorphans2_var)
ift		init gisine

a1		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift
a1		*= .5 + lfo:a(.5, icpsvar + randomi:k(-icpsvar, icpsvar, 1/idur))

a2		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift
a2		*= .5 + lfo:a(.5, icpsvar*3 + randomi:k(-icpsvar, icpsvar, 1/idur))

a3		oscil3 $ampvar, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift
a3		*= .5 + lfo:a(.5, icpsvar*4 + randomi:k(-icpsvar, icpsvar, 1/idur))

k1     	   line           1,		p3, 0
k2         line           -5.5,		p3, 0
k3         line           -$M_PI*2,	p3, -$M_PI_2
k4         expon           5,		p3, $M_PI*4
k5         expon           1.5,		p3, 0.75*8
k6         line           25*iamp,		p3, -1*2

aosc		= a1 + a2 + a3
aosc		/= 3

acheby		chebyshevpoly  aosc, 25*iamp, k1*iamp, k2, k3, k4, k5*iamp, k6
aout		balance2 acheby, aosc

ienvvar		init idur/5

	$death

	endin
