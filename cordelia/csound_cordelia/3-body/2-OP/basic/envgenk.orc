
	opcode envgenk, k, ii
	idur, iftenv	xin
	
ifenvmod	init	floor(iftenv)-iftenv
iftenvreal	abs	floor(iftenv)
idur_env init gienvdur-1
imax init 1

if	ifenvmod == 0 then

	if	iftenv > 0 then
		klinenv	linseg 0, idur, idur_env
	else
		klinenv	linseg idur_env, idur, 0
	endif

else 

	iatk	abs ifenvmod

	if	iftenv > 0 then

		ires	init 0
		indx	init 0
		ilast	init idur-iatk
		
		until ires==imax do
			ires	table3 indx, abs(iftenv)
			ires 	= round(ires * 1000) / 1000
			indx	+= 1
		od

		if	iatk<ilast then
			klinenv	linseg 0, iatk, indx, ilast, idur_env
		else
			klinenv	linseg 0, idur, idur_env
		endif

	else

		ires	init 0
		indx	init 0
		ilast	init idur-iatk
			
		until ires==imax do
			ires	table3 indx, abs(iftenv)
			ires	= round(ires * 1000) / 1000
			indx	+= 1
		od
		
		if	iatk<ilast then
			klinenv	linseg idur_env, ilast, indx, iatk, 0
		else
			klinenv	linseg idur_env, idur, 0
		endif

	endif

endif


	kenv	table3 klinenv, iftenvreal

	;idec	init 295 / sr
	;aenv	*= cosseg:a(0, idec, 1, idur-(idec*2), 1, idec, 0)

	xout kenv
	endop


