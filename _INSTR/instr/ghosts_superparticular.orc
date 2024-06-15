
gighosts_superparticular_ratios[] fillarray \
											2/1, \
											3/2, \
											4/3, \
											5/4, \
											6/5, \
                                            7/6, \
                                            8/7, \
                                            9/8, \
											10/9, \
                                            11/10, \
                                            12/11, \
											13/12, \
                                            14/13, \
											15/14, \
                                            16/15

gighosts_superparticular_length lenarray gighosts_superparticular_ratios

$start_instr(ghosts_superparticular)

	iratio init gighosts_superparticular_ratios[random(0, gighosts_superparticular_length)]
	icps *= iratio
	icps_end = icps * iratio
	until icps > 20 && icps < 15$k do
		icps /= 2
	od

	schedule "ghosts_superparticular_instr", 0, idur, idyn/random:i(3, 6), ienv, icps*2, ich, icps_end*2

	turnoff

endin

instr ghosts_superparticular_instr

	$params(ghosts_superparticular)
	icps_end init p8
	ain		fractalnoise $dyn_var, expseg(.95, idur, .05)

	ain		*= .5+lfo:a(.5, random:i(.95, 1.35))*cosseg:a(0, idur, 1)

	imax		init 1
	acps		= 1 / expseg:a(icps, idur, icps_end)
	krvt		cosseg idur, idur, idur/random:i(2, 12)
	aout		vcomb ain/3, krvt, acps, imax
	aout		moogladder2 aout, limit(cosseg:a(icps*11*idyn, idur*10/11, icps*2, idur/11, icps), icps, 15$k), .5+jitter:k(.35, 8/idur, 3/idur)
	
	$dur_var(5)

$end_instr
