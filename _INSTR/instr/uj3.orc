
giuj3_morf			ftgen 0, 0, gioscildur, 10, 1
giuj3_ft			ftgen 0, 0, 2, -2, gisquare, gisaw, gitri

instr uj3
	$params(uj3_instr)
	inum init nstrnum(Sinstr)+ich/100
	schedule inum, 0, -(idur+.05), idyn, ienv, icps, ich
	turnoff
endin

instr uj3_instr
	$params(uj3)

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
		kcps	cosseg icps, iport, icps/pow(2, int(random:i(2, 3))), iport, icps

	elseif (p3 < 0 && itie == 1) then
		;prints "TIED: MIDDLE NOTE\n"
		aenv	cosseg idyn_last, iport, idyn
		kcps	cosseg icps_last, iport, icps_last/pow(2, int(random:i(2, 3))), iport, icps
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

			ftmorf abs:k(jitter:k(1, 1/idur, 2/idur))*(ftlen(giuj3_ft)-1), giuj3_ft, giuj3_morf

					;kamp, kcps, kx, ky, krx, kry, krot, ktab0, ktab1, km1, km2, kn1, kn2, kn3, ka, kb, kperiod
	aout	wterrain2 1, kcps, 0.5, 0.5, 0.75, 0.35, portk(idyn, iport*2, idyn_last), gisine, giuj3_morf, random:i(0, 8), 5+jitter:k(1, 1/idur, .5/idur)
	aout	K35_lpf aout, portk(20$k-((1-idyn)*15.5$k), iport*2, 20$k-((1-idyn_last)*15.5$k)), 5+jitter:k(1, 1/idur, .5/idur), 1, 1+idyn, itie
	aout 	*= aenv

	$dur_var(10)
	$channel_mix
endin