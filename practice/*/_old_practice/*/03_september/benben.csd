	instr Score

gkpulse	= 195

kbb	= bentab(3, 8, 1)

if (eu(3, 8, 16, "heart") == 1) then
	e("wendy",
	gkbeats*kbb,
	pump(4, fillarray($ff, $p)),
	kbb*30)
endif

if (eu(5, 8, 16, "heart") == 1) then
	e("wendy",
	gkbeats/kbb,
	pump(6, fillarray($ff, $p)),
	kbb*45)
endif

if (eu(7, 8, 16, "heart") == 1) then
	e("wendy",
	gkbeats/kbb,
	pump(8, fillarray($ff, $mf)),
	kbb*50)
endif

	endin
	start("Score")

	instr Route
getmeout("wendy")
	endin
	start("Route")
