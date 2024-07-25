instr noijs
	$params(noijs_instr)
	inum init nstrnum(Sinstr)+ich/100
	schedule inum, 0, -(idur+.05), idyn, ienv, icps, ich
	turnoff
endin

instr noijs_instr
	$params(noijs)

	itie	tival
	iport	init idur/12
	until iport < idur/4 do
		iport /= 2
	od

	iatk		init ienv-floor(ienv)

	indx	init 0
	ires	init 0
	ilast	init idur-iatk
	until ires == 1 do
		ires	table3 indx, abs(floor(ienv))
		ires 	= round(ires * 1000) / 1000
		indx	+= 1
	od
	if iatk == 0 then
		iatk init indx / sr
	endif


	iphase init -1
	ktime 	init 0

	tigoto SKIP_INIT
		iphase init 0
		; if it is tied note skip this
		icps_last 	init icps
		idyn_last 	init idyn

	SKIP_INIT:
	if (itie == 0 && p3 < 0) then
		;prints "TIED: INITIAL NOTE\n"
		aenv	= table3:a(linseg:a(0, iatk, indx), ienv)*idyn
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
		turnoff2 p1, 0, 1
	endif

	irel_time init idur/6

		xtratim irel_time
	krel release
	if krel == 1 then
		icps_rel init icps_last/2
		while icps_rel > 20 do
			icps_rel /= 2
		od

		aenv	= table3:a(linseg:a(indx, irel_time, gienvdur-1), ienv)*idyn
		kcps	cosseg icps_last, irel_time, icps_rel
	endif


	tigoto SKIP_INIT2


		i1div2pi		init $M_PI/2

		kpeakdev		= $dyn_var * 2 * i1div2pi
		kpeakdev2		= $dyn_var * cosseg(3, idur, 5) * i1div2pi

		;STEREO "CHORUS" ENRICHMENT USING JITTER
		kjitR			jitter cosseg(5, idur, .75), 1.5, 3.5

		;MODULATORS
		if ienv > 0 then
			istart	init 0
			iend	init 1
		else
			istart	init 1
			iend	init 0
		endif
		ienv_abs	abs ienv

		aModulator		oscili	kpeakdev*tablei(linseg(istart, idur/2, iend), ienv_abs, 1), kcps * 5, gisine, iphase
		aModulator2		oscili	kpeakdev2*tablei(linseg(istart, idur/3, iend), ienv_abs, 1), kcps * 2, gitri, iphase

		avib1			= lfo(kcps/35, kcps/250)*cosseg(0, idur, 1)

		aCarrierR		phasor	portk(kcps + kjitR, idur/96, 20)+avib1, iphase
		aCarrierR		table3	aCarrierR + aModulator + aModulator2, gisaw, 1, 0, 1
		aSigR			= aCarrierR * $dyn_var
		aSigR			*= .75+lfo(.25, random:i(2.95, 3.05)*cosseg(1, idur, 3))
		aout			bqrez	aSigR, kcps+(kcps*(16*$dyn_var)), .75, 0, itie

	SKIP_INIT2:
	aout 			*= aenv
	$dur_var(10)
	$channel_mix
endin

