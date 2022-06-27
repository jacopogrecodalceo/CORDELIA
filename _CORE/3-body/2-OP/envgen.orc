gimorf		ftgen 0, 0, gienvdur, 10, 1
gimorfsyn		ftgen 0, 0, gioscildur, 10, 1

	opcode envgen, a, ii
	idur, iftenv	xin
	
ifenvmod	init	floor(iftenv)-iftenv
iftenvreal	abs	floor(iftenv)

if	ifenvmod == 0 then

	if	iftenv > 0 then
		alinenv	linseg 0, idur, gienvdur
	else
		alinenv	linseg gienvdur, idur, 0
	endif

else 

	iatk	abs ifenvmod

	if	iftenv > 0 then

		ires	init 0
		indx	init 0
		ilast	init idur-iatk
		
		until ires==1 do
			ires	table3 indx, abs(iftenv)
			indx	+= 1
		od

		if	iatk<ilast then
			alinenv	linseg 0, iatk, indx, ilast, gienvdur
		else
			alinenv	linseg 0, idur, gienvdur
		endif

	else

		ires	init 0
		indx	init 0
		ilast	init idur-iatk
			
		until ires==1 do
			ires	table3 indx, abs(iftenv)
			indx	+= 1
		od
		
		if	iatk<ilast then
			alinenv	linseg gienvdur, ilast, indx, iatk, 0
		else
			alinenv	linseg gienvdur, idur, 0
		endif

	endif

endif

if	iftenvreal==gimorf then
	amorf	table3 alinenv, iftenvreal
	aramp	table3 alinenv, gisotrap
	aenv	= amorf*aramp
else
	aenv	table3 alinenv, iftenvreal
endif

	xout aenv
	endop
