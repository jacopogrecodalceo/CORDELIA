
instr uj2
	$params(uj2_instr)
	inum init nstrnum(Sinstr)+ich/100
	schedule inum, 0, -(idur+.05), idyn, ienv, icps, ich
	turnoff
endin

instr uj2_instr
	$params(uj2)

	itie	tival
	iport	init idur/12
	until iport < idur/4 do
		iport /= 2
	od

	iatk	init .05
	until iatk < idur do
		iatk /= 2
	od


	iphase 	init -1
	ktime 	init 0

	tigoto SKIP_INIT
		; if it is tied note skip this
		iphase 		init 0
		icps_last 	init icps
		idyn_last 	init idyn

	SKIP_INIT:
	if (itie == 0 && p3 < 0) then
		;prints "TIED: INITIAL NOTE\n"
		aenv	cosseg 0, iatk, idyn
		kcps	cosseg icps, iport, icps/pow(2, random:i(2, 3)), iport, icps

	elseif (p3 < 0 && itie == 1) then
		;prints "TIED: MIDDLE NOTE\n"
		aenv	cosseg idyn_last, iport, idyn
		kcps	cosseg icps_last, iport/2, icps_last/pow(2, random:i(2, 3)), iport/2, icps
		icps_last init icps
		idyn_last init idyn
	endif

	ktime timeinsts
	if ktime > idur then
		turnoff2 p1, 4, 1
	endif

	irel_time init idur/6

		xtratim irel_time
	krel release
	if krel == 1 then
		icps_rel init icps_last/2
		while icps_rel > 20 do
			icps_rel /= 2
		od

		aenv	cosseg idyn_last, irel_time, 0
		kcps	cosseg icps_last, irel_time, icps_rel
	endif

	kbuzz_cps = kcps / 100
	abuzz	buzz 1, kcps, 12-ceil(kbuzz_cps), gitri, itie
	abuzz	zdf_ladder abuzz, limit(15$k-jitter:k(1, 1/idur, .5/idur)*kcps*4, 20, 20$k), 7.25+jitter:k(5, 1/idur, .5/idur), itie


	avco	vco2 1, kcps, itie
	avco	zdf_ladder avco, limit(kcps*2+jitter:k(1, 1/idur, .5/idur)*kcps, 20, 20$k), 7.25+jitter:k(5, 1/idur, .5/idur), itie

	aout	= (abuzz + avco) / 4

	aout *= aenv

	$dur_var(10)
	$channel_mix
endin