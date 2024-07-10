;orphans3 without no vibrato

instr orphans3xv
	$params(orphans3xv_instr)
	inum init nstrnum(Sinstr)+ich/100
	schedule inum, 0, -(idur+.05), idyn, ienv, icps, ich
	turnoff
endin

instr orphans3xv_instr
	$params(orphans3xv)

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

		icps_var		init icps/100
		ift1			init gisine
		ift2			init gitri

		k0		init 0;random:i(0, .05)
		k1		init random:i(0, 1)
		k2		init random:i(-.5, 0)
		k3		init random:i(-1/3, -1)
		k4		init random:i(0, .5)
		k5		init random:i(0, .7)
		k6		init random:i(0, 1)

		iq		random 0, .95

	SKIP_INIT:
	if (itie == 0 && p3 < 0) then
		;prints "TIED: INITIAL NOTE\n"
		aenv		= table3:a(linseg:a(0, iatk, indx), ienv)*idyn
		kcps	init icps

	elseif (p3 < 0 && itie == 1) then
		;prints "TIED: MIDDLE NOTE\n"
		aenv		cosseg idyn_last, iport, idyn
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
		aenv	= table3:a(linseg:a(indx+1, irel_time, gienvdur), ienv)*cosseg(idyn_last, iport, idyn)
		kcps	cosseg icps_last, irel_time, icps_rel

	endif

	a1		oscil3 1, kcps + lfo:a(icps_var, icps_var/int(random:i(15, 25))), ift1, iphase

	a2		oscil3 1, kcps + lfo:a(icps_var, icps_var/int(random:i(15, 25))), ift1, iphase

	a3		oscil3 1, kcps + lfo:a(icps_var, icps_var/int(random:i(15, 25))), ift2, iphase

	;a3			chebyshevpoly  a3, k6, k5, k4, k3, k2, k1, k0
	kcps_moog = limit(15$k - (kcps * (1-aenv) * 15), 20, 20$k)
	a3		moogladder2 a3, kcps_moog, iq, itie

	aout		= (a1 + a2 + a3) / 3

	aout			chebyshevpoly  aout, k0, k1, k2, k3, k4, k5, k6
	aout 			*= aenv

	$channel_mix
endin