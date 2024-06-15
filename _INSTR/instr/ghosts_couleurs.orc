gighosts_couleurs_cps_last init 0

	$start_instr(ghosts_couleurs)

;iopts[]		fillarray gighosts_couleurs_cps_last + icps, 2*gighosts_couleurs_cps_last + icps, gighosts_couleurs_cps_last + 2*icps, 3*gighosts_couleurs_cps_last + 2*icps, 3*gighosts_couleurs_cps_last + 3*icps, 5*gighosts_couleurs_cps_last + 3*icps, 4*gighosts_couleurs_cps_last + 5*icps, 8*gighosts_couleurs_cps_last + 6*icps
iopts[]		fillarray	gighosts_couleurs_cps_last + icps, \
						2*gighosts_couleurs_cps_last + icps, \
						gighosts_couleurs_cps_last + 2*icps, \
						3*gighosts_couleurs_cps_last + 2*icps, \
						3*gighosts_couleurs_cps_last + 3*icps, \
						5*gighosts_couleurs_cps_last + 3*icps, \
						4*gighosts_couleurs_cps_last + 5*icps, \
						8*gighosts_couleurs_cps_last + 6*icps, \
						gighosts_couleurs_cps_last - icps, \
						2*gighosts_couleurs_cps_last - icps, \
						gighosts_couleurs_cps_last - 2*icps, \
						3*gighosts_couleurs_cps_last - 2*icps, \
						3*gighosts_couleurs_cps_last - 3*icps, \
						5*gighosts_couleurs_cps_last - 3*icps, \
						4*gighosts_couleurs_cps_last - 5*icps, \
						8*gighosts_couleurs_cps_last - 6*icps

ilen		lenarray iopts

if gighosts_couleurs_cps_last != 0 then
	iopt init iopts[random(0, ilen)]
	until iopt > 20 && iopt < 15$k do
		iopt init iopts[random(0, ilen)]
	od
	schedule "ghosts_couleurs_instr", random:i(0, idur/2), idur, idyn/random:i(3, 6), ienv, iopt, ich
endif
	gighosts_couleurs_cps_last init icps
	turnoff
	endin

	instr ghosts_couleurs_instr
	$params(ghosts_couleurs)

icpsvar		init icps/100
ift1		init gisine
ift2		init gitri
idyn_factor	init 1/3

a1		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a1		*= .5 + lfo:a(.5, .25)

a2		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift1
a2		*= .5 + lfo:a(.5, .25*2)

a3		oscil3 $dyn_var, icps + lfo:a(icpsvar, icpsvar/int(random:i(1, 5))), ift2
a3		*= .5 + lfo:a(.5, .25*3)

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

; avoid clicks, scale final amplitude, and output
ideclick_atk	init .05
adeclick		linseg 0, ideclick_atk, 1, idur - (ideclick_atk*2), 1, ideclick_atk, 0

aout		dcblock2 acheby*idyn_factor*adeclick;+aosc*(1-adeclick)

	$dur_var(5)
	$end_instr
