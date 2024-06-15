	$start_instr(orphans)

icpsvar		init icps/100

if icps/2 > 23.5 then
	asub		oscil3 $dyn_var, (icps + randomi:k(-icpsvar, icpsvar, 1/idur))/random:i(1.95, 2.15), gisine
	asub		*= .55 + lfo:a(.45, (icpsvar/4) + randomi:k(-icpsvar/8, icpsvar/8, 1/idur))
endif

a1		oscil3 $dyn_var, icps + randomi:k(-icpsvar, icpsvar, 1/idur), gisine
a1		*= .75 + lfo:a(.25, (icpsvar/6) + randomi:k(-icpsvar/8, icpsvar/8, 1/idur))

k1     	   line           1.0,		p3, 0
k2         line           -0.5,		p3, 0
k3         line           -$M_PI,	p3, -$M_PI_2
k4         line           0,		p3, $M_PI
k5         line           0,		p3, 0.75
k6         line           0,		p3, -1

across1, across2	crossfm icpsvar/3, icpsvar*1.35*idyn, k4*random:i(1, 3), k5, cosseg(icps, p3, icps/random:i(.955, .995)), gisine, gisine
across3, across4	crossfm icpsvar*1.35*idyn, icpsvar/3, abs(k3), abs(k2)*random:i(1, 3), expseg(icps, p3, icps/random:i(1.025, 1.005)), gisine, gisine

across		= across1 + across2 + across3 + across4
across		*= idyn/48

aosc		= (asub/3) + a1 + across
aosc		/= 3

acheby		chebyshevpoly  aosc, 0, k1*idyn, k2, k3, k4, k5*idyn, k6

aout		balance2 acheby, aosc
aout		dcblock2 aout

		$dur_var(5)
		$end_instr
