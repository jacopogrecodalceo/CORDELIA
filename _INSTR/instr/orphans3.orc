gkorphans3_vib init .25

		$start_instr(orphans3)

icpsvar		init icps/100
ift1		init gisine
ift2		init gitri

a1		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a1		*= .5 + lfo:a(.5, gkorphans3_vib)

a2		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a2		*= .5 + lfo:a(.5, gkorphans3_vib*2)

a3		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift2
a3		*= .5 + lfo:a(.5, gkorphans3_vib*3)

a3		moogladder2 a3, icps*2+(cosseg(icps, idur/2, icps*24, idur/2, icps/2)*$dyn_var), .5*cosseg(.25, p3, .85)

k1     	   line           1,		p3, 0
k2         line           -5.5,		p3, 0
k3         expon           -7,		p3, -3
k4         expon           5,		p3, 9
k5         expon           1.5,		p3, 0.75*8
k6         line           25*idyn,	p3, -1*2

aosc		= a1 + a2 + a3
aosc		/= 2

acheby		chebyshevpoly  aosc, 25*idyn, k1*idyn, k2, k3, k4, k5*idyn, k6
;acheby		skf acheby, 35, 1.586

aout		balance2 acheby, aosc
aout		dcblock2 aout

	$dur_var(5)
	$end_instr
