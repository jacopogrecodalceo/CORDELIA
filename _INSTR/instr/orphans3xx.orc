;orphans3 without artifacts

gkorphans3xx_vib init .25

		$start_instr(orphans3xx)

icpsvar		init icps/100
ift1		init gisine
ift2		init gitri

a1		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a1		*= .5 + lfo:a(.5, gkorphans3xx_vib)

a2		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a2		*= .5 + lfo:a(.5, gkorphans3xx_vib*2)

a3		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift2
a3		*= .5 + lfo:a(.5, gkorphans3xx_vib*3)

a3		moogladder2 a3, icps*2+(cosseg(icps, idur/2, icps*24, idur/2, icps/2)*$dyn_var), .5*cosseg(.25, p3, .85)

k1		init random:i(-1, 1)
k2		init random:i(-1, 1)
k3		init random:i(-1, 1)
k4		init random:i(-1, 1)
k5		init random:i(-1, 1)
k6		init random:i(-1, 1)

aosc		= a1 + a2 + a3
aosc		/= 2

acheby		chebyshevpoly  aosc, 25*idyn, k1*idyn, k2, k3, k4, k5*idyn, k6
;acheby		skf acheby, 35, 1.586

aout		balance2 acheby, aosc
aout		dcblock2 aout

	$dur_var(5)
	$end_instr
