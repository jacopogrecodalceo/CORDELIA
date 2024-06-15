	instr SCORE

gkpulse	= 125 + lfo(5,gkbeatf/4)

if (eu(3, pump(4, fillarray(9, 24)), 16, "heart") == 1) then
	e("repuck",
	gkbeats,
	scall("4G", gilocrian, pump(3, fillarray(3, 3, 2, 2, 7))),
	$f)
endif

if (eu(3, pump(4, fillarray(9, 24)), pump(2, fillarray(16, 24)), "heart") == 1) then
	e("repuck",
	gkbeats,
	scall("4Bb", gidorian, pump(6, fillarray(3, 3, 2, 2, 7))),
	$f)
endif
	endin
	start("SCORE")

	instr ROUTE
kdyn	= lfo(1, gkbeatf/randomi:k(1, 4, gkbeatf/4), 3)*abs(lfo(1, gkbeatf/16))
chnset(.5+lfo(.45, gkbeatf/4), "delirium.fb")
chnset(gkbeats/randomi:k(2, 12, gkbeatf/4), "delirium.time")
routemeout("repuck", "delirium")
routemeout("repuck", "twinkle", kdyn)
routemeout("repuck", "bribes", kdyn)
getmeout("repuck")
	endin
	start("ROUTE")

