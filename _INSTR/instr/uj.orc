
instr uj
	$params(uj_instr)
	inum init nstrnum(Sinstr)+ich/100
	schedule inum, 0, -(idur+.05), idyn, ienv, icps, ich
	turnoff
endin

instr uj_instr
	$params(uj)

	itie	tival
	iport	init idur/24
	until iport < idur do
		iport /= 2
	od

	iatk	init .05
	idec	init .05

	iphase init -1
	ktime init 0

	tigoto SKIP_INIT
		; if it is tied note skip this
		iphase init 0
		icps_last init icps
		idyn_last init idyn

	SKIP_INIT:
	if (itie == 0 && p3 < 0) then
		;prints "TIED: INITIAL NOTE\n"
		aenv	cosseg 0, iatk, idyn
		kcps	init icps

	elseif (p3 < 0 && itie == 1) then
		;prints "TIED: MIDDLE NOTE\n"
		aenv	cosseg idyn_last, iport, idyn
		kcps	cosseg icps_last, iport, icps
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

	aosc	oscili 1, kcps*2, gitri, iphase

	avco	vco2 1, kcps, itie
	avco	zdf_ladder avco, limit(kcps*2+jitter:k(1, 1/idur, .5/idur)*kcps, 20, 20$k), 7.25+jitter:k(5, 1/idur, .5/idur), itie

	aout	= (aosc + avco) / 4

	aout *= aenv

	$dur_var(10)
	$channel_mix
endin