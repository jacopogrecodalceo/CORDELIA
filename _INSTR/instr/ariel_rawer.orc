
	instr ariel_rawer

idur	init p3

idyn	init p4
ienv	init p5
icps 	init p6
ich		init p7
imod	init ich % 1

    schedule nstrnum("ariel_rawer_instr")+ich/1000 + imod, 0, idur, idyn, ienv, icps, ich

    turnoff
    endin

	instr ariel_rawer_instr
	$params(ariel_rawer)
	$dur_var(10)

; these values are skipped if tied
tigoto SKIP_I
	iatk 			init idur / 3
	until iatk < 5 do
		iatk /= 2
	od

SKIP_I:

	itie, itiestatus	tie_status

	if 		itiestatus == -1 then
		;prints "SINGLE NOTE\n"

		while iatk >= idur do
			iatk /= 2
		od

		isus			random .75, 1
		irel			init 1/16
						xtratim irel

		adyn_line		init idyn
		aenv			cossegr 0, iatk, 1, idur - iatk, isus, irel, 0
		kcps_line		init icps

	elseif itiestatus == 0 then
		;prints "TIED: INITIAL NOTE\n"

		aenv			cosseg 0, iatk, 1
		adyn_line		init idyn
		kcps_line		init icps

		idyn_last		init idyn
		icps_last		init icps
		
	elseif itiestatus == 1 then
		;prints "TIED: MIDDLE NOTE\n"

		aenv			init 1
		adyn_line		cosseg idyn_last, idur, idyn
		kcps_line		cosseg icps_last, idur, icps

		idyn_last		init idyn
		icps_last		init icps

	elseif itiestatus == 2 then
		;prints "TIED: END NOTE\n"
		aenv        	cossegr	1, idur, isus/16, irel, 0
		adyn_line		cosseg idyn_last, idur, idyn
		kcps_line		cosseg icps_last, idur, icps

	endif

tigoto SKIP_K
	; if it is TIED note skip this
	;kjitter_cps = jitter(3, 1/32, .5/64)*kcps_line
	kjitter_q   = 5.25+jitter(3, 1/3, 1/64)
	kcps_ladder	limit kcps_line*12+jitter(kcps_line/12, 1/32, 1/64), 20, 20000
	kcar		abs kcps_ladder/kcps_line

	kjit_cps init 0
	if randomi:k(0, 1, randomi:k(1, 5, 1, 3)) > .95 then
		kjit_cps	randomh -kcps_line/4, kcps_line/4, randomi:k(3, 9, 5, 3), 3
		;kjit_cps	+= jitter(kjit_cps/2, 1/2, 1)
	else
		kjit_cps	= 0
	endif

	kjit_dyn init 0
	if kjit_cps < 0 then
		kjit_dyn	= abs(kjit_cps*2) / kcps_line
	elseif kjit_cps > 0 then
		kjit_dyn	= abs(kjit_cps*2) / kcps_line
	else
		kjit_dyn = 0
	endif
	kjit_dyn portk kjit_dyn, ksmps/sr * 12

	kgauss      gauss 0, .025
	kran		randomi 0, 1, 5
	ksign   	= (kran < .105 ? -1 : 1)

	kjit_cps 	portk kjit_cps, abs(kgauss) * ksign, icps
	;printks2 "sign: %f\n", ksign
	;printks2 "cps: %f\n", kjit_cps
SKIP_K:

	avco1	    vco2 1, limit(kcps_line+kjit_cps, 20, 20000), itie
	avco1		K35_lpf avco1, limit(kcps_ladder+kjit_cps, 20, 20000), kjitter_q, 1, 1.25+kjit_dyn, itie

	; 2nd vco

	kpeakdev		= adyn_line * 2 * .1592
	kpeakdev2		= adyn_line * 3+jitter(2, 1/4, 1) * .1592
	amod			oscili	kpeakdev*(.5+jitter(.5, .5, 1)), kcps_line * 5, gisine, itie*-1
	amod2			oscili	kpeakdev2*(.5+jitter(.5, .5, 1)), kcps_line * 2, gitri, itie*-1

	avib1			= oscili:a(icps/35, icps/250, gisine, itie*-1)

	acar		phasor	limit(kcps_line+(kcps_line-kjit_cps), 20, 20000)+avib1
	acar		table3	acar + amod + amod2, gisaw, 1, 0, itie*-1
	asig		= acar * adyn_line
	avco2		bqrez	asig, limit(kcps_ladder*3+kjit_cps, 20, 20000), 1-(kjitter_q/(5.25+3))

	aout		sum avco1, avco2

	aout		*= (1 + kjit_dyn)
	aout		= aout*aenv*adyn_line / 2

	$end_instr



