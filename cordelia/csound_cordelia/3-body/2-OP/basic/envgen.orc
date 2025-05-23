gisotrap_ramp		init 32 ; in samps
gisotrap_seg		init gienvdur-(gisotrap_ramp*2)
;-----------------------
gisotrap		ftgen	0, 0, gienvdur, 7, 0, gisotrap_ramp, 1, gisotrap_seg, 1, gisotrap_ramp, 0

	opcode envgen, a, ii
	idur, iftenv	xin
	
ifenvmod	init	floor(iftenv)-iftenv
iftenvreal	abs	floor(iftenv)
iexists 	ftexists iftenvreal

if iexists != 1 || iftenvreal == 0 then
	iftenvreal = gisotrap
	printks "WARNING ENVGEN DOESN'T EXIST\n", 1/2
endif

idur_env init gienvdur-1
imax init 1

if	ifenvmod == 0 then

	if	iftenv > 0 then
		alinenv	linseg 0, idur, idur_env
	else
		alinenv	linseg idur_env, idur, 0
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
			alinenv	linseg 0, iatk, indx, ilast, idur_env
		else
			alinenv	linseg 0, idur, idur_env
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
			alinenv	linseg idur_env, ilast, indx, iatk, 0
		else
			alinenv	linseg idur_env, idur, 0
		endif

	endif

endif


	aenv	table3 alinenv, iftenvreal

	;idec	init 295 / sr
	;aenv	*= cosseg:a(0, idec, 1, idur-(idec*2), 1, idec, 0)

	xout aenv
	endop


