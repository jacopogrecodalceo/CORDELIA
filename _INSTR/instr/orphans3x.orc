gkorphans3x_vib init .25

		$start_instr(orphans3x)

ift1		init gisine
ift2		init gisaw

a1		oscil3 1, icps, ift1
a1		*= .5 + lfo:a(.5, gkorphans3x_vib)

a2		oscil3 1, icps, ift1
a2		*= .5 + lfo:a(.5, gkorphans3x_vib*2)

a3		oscil3 1, icps, ift2
a3		*= .5 + lfo:a(.5, gkorphans3x_vib*3)
a3		skf a3, icps*2+(cosseg(icps, idur/2, icps*24, idur/2, icps/2)*$dyn_var), cosseg(.05, idur, 2.85)

k1		= abs(jitter(1,	16/idur, 1/idur))
k2		= abs(jitter(1,	16/idur, 1/idur))
k3		= abs(jitter(1,	16/idur, 1/idur))
k4		= abs(jitter(1,	16/idur, 1/idur))
k5		= abs(jitter(1,	16/idur, 1/idur))
k6		= abs(jitter(1,	16/idur, 1/idur))

aosc		= (a1 + a2 + a3)*$dyn_var

acheby		chebyshevpoly  aosc, 25*idyn, k1, k2, k3, k4, k5*idyn, k6*idyn
aout		balance2 acheby, aosc

aout		dcblock2 aout

	$dur_var(5)
	$end_instr
