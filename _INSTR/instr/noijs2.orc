
ginoijs2_count init 0

instr noijs2
	$params(noijs2_instr)

	inum 	init nstrnum(Sinstr)+(ginoijs2_count/100)+ich/1000
	schedule inum, 0, -(idur+.05), idyn, ienv, icps, ich
	ginoijs2_count += 1
	if ginoijs2_count > 4 then
		ginoijs2_count init 0
	endif
	turnoff
endin

instr noijs2_instr
	$params(noijs2)

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

		aenv	= table3:a(linseg:a(indx, ilast, gienvdur-1), ienv)*idyn
		kcps	cosseg icps_last, irel_time, icps_rel
	endif

	tigoto SKIP_INIT2

		i1div2pi		init $M_PI

		kpeakdev		= $dyn_var * 2 * i1div2pi
		kpeakdev2		= $dyn_var * cosseg(13, idur, random:i(3, 9)) * i1div2pi

		;STEREO "CHORUS" ENRICHMENT USING JITTER
		kjit			jitter cosseg(5, idur, 1.75), 1.5, 3.5

		;MODULATORS
		if ienv > 0 then
			istart	init 0
			iend	init 1
		else
			istart	init 1
			iend	init 0
		endif
		ienv_abs	abs ienv

	SKIP_INIT2:

	amodulator		oscili	kpeakdev*table3(linseg(istart, idur/2, iend), ienv_abs, 1), kcps * 5, gisine, iphase
	amodulator2		oscili	kpeakdev2*table3(linseg(istart, idur/3, iend), ienv_abs, 1), kcps, gitri, iphase

	kvib			= lfo(kcps/35, kcps/250)*cosseg(0, idur, 1)

	acarrier		phasor	portk(kcps + kjit, idur/9, 20)+kvib, iphase
	acarrier		table3	acarrier + amodulator + amodulator2, gisquare, 1, 0, 1
	asig			= acarrier * $dyn_var
	asig			*= .75+lfo(.25, cosseg(.5, idur, 9.05)*kcps/1000)*cosseg(0, idur, 1)
	aout			bqrez	asig, 15$k-$dyn_var*13$k, .75+jitter(.15, .5, 3), 0, itie


	aout 			*= aenv
	aout			*= $dyn_var
	$dur_var(10)
	$channel_mix
endin

