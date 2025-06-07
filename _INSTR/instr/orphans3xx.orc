;orphans3 without artifacts

gkorphans3xx_vib init .25

		$start_instr(orphans3xx)

icpsvar		init icps/100
ift1		init gisine
ift2		init gitri
idyn_factor	init 1/3

a1		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a1		*= .5 + lfo:a(.5, gkorphans3xx_vib)

a2		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a2		*= .5 + lfo:a(.5, gkorphans3xx_vib*2)

a3		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift2
a3		*= .5 + lfo:a(.5, gkorphans3xx_vib*3)

a3		moogladder2 a3, limit(icps*2+(cosseg(icps, idur/2, icps*24, idur/2, icps/2)*$dyn_var), 20, 20$k), .5*cosseg(.25, p3, .85)

k0		init idyn
k1		init random:i(-1, 1)
k2		init random:i(-1, 1)
k3		init random:i(-1, 1)
k4		init random:i(-1, 1)
k5		init random:i(-1, 1)
k6		init random:i(-1, 1)

aosc		= a1 + a2 + a3
aosc		/= 3

acheby		chebyshevpoly  aosc, k0, k1*idyn, k2, k3, k4, k5*idyn, k6
/* 
; avoid clicks, scale final amplitude, and output
ideclick_atk	init .05
adeclick		linseg 0, ideclick_atk, 1, idur - (ideclick_atk*2), 1, ideclick_atk, 0

aout			dcblock2 acheby*idyn_factor*adeclick;+aosc*(1-adeclick) */
aout	butterhp acheby, 20
	$dur_var(5)
	$end_instr
