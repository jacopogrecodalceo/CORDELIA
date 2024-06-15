gkstep		init 0
gkdyn		init 0

	instr controlme

knum	= nstrnum("score")+.1

kstep	pump 1, fillarray(5, 3, 2, 7, 5, 4, 2, 5)

ktrig	= changed(kstep)

kscale init giminor3

	schedkwhen ktrig, .25, 15, knum, 0, -1, kstep, kscale

getmeout("cascade")
getmeout("aaron")
getmeout("witches")
getmeout("wendy")

	endin
	start("controlme")

	instr score

kstep[] fillarray 1, 3, 2, p4, 3, 1, 2, 1, 1, 1
kdyn[]	fillarray 1, 6, 4, 7, 4, 1, 4, 1, 1, 1

$if	eu(16, 16, 16, "heart") $then
	e("cascade",
	gkbeats*(kdyn[gkdyn]/2),
	$mf*(kdyn[gkdyn]/7),
	step("3B", p5, kstep[gkstep]))

	gkdyn		+= 1
	gkdyn		= gkdyn % lenarray(kdyn)
	
	gkstep		+= 1
	gkstep		= gkstep % lenarray(kstep)
endif

$if	eu(8, 16, 16, "heart") $then
	e("aaron",
	gkbeats*(kdyn[gkdyn])*lfse(.125, 1, 255),
	$p*(kdyn[gkdyn]/7),
	step("5B", p5, kstep[gkstep]))

	gkdyn		+= .125
	gkdyn		= gkdyn % lenarray(kdyn)
	
	gkstep		+= .25
	gkstep		= gkstep % lenarray(kstep)
endif

$if	eu(3, 8, 4, "heart") $then
	e("witches",
	gkbeats*(kdyn[gkdyn]),
	$f*(kdyn[gkdyn]/7),
	step("4F#", p5, kstep[gkstep]),
	step("4B", p5, kstep[gkstep]))

	gkdyn		+= .25
	gkdyn		= gkdyn % lenarray(kdyn)
	
	gkstep		+= .25
	gkstep		= gkstep % lenarray(kstep)
endif

$if	eu(3, 21, 2, "heart") $then
	e("wendy",
	gkbeats*(kdyn[gkdyn]*4),
	$mp*(kdyn[gkdyn]/7),
	step("3F#", p5, kstep[gkstep]),
	step("2B", p5, kstep[gkstep]))

	gkdyn		+= .33
	gkdyn		= gkdyn % lenarray(kdyn)
	
	gkstep		+= .33
	gkstep		= gkstep % lenarray(kstep)
endif


	endin
