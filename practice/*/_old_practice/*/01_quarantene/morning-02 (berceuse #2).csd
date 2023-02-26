	instr SCORE

gkpulse	= 125 + lfo(5, gkbeatf/4)

if (eu(3, pump(4, fillarray(9, 24)), 16, "heart") == 1) then
	e("repuck",
	gkbeats,
	heartmurmur(24, $ff),
	scall("4G", gilocrian, pump(3, fillarray(3, 3, 2, 2, 7))))
endif

if (eu(3, pump(4, fillarray(9, 24)), pump(2, fillarray(16, 24)), "heart") == 1) then
	e("repuck",
	gkbeats,
	heartmurmur(24, $ff),
	scall("4Bb", gidorian, pump(6, fillarray(3, 3, 2, 2, 7))))
endif

if (eu(3, 9, 3, "heart") == 1) then
	e("juliet",
	gkbeats*4,
	heartmurmur(24, $mf),
	scall("4Bb", gidorian, pump(3, fillarray(3, 3, 2, 2, 7))))
endif

if (eu(5, 9, 3, "heart") == 1) then
	e("juliet",
	gkbeats*4,
	heartmurmur(24, $mf),
	scall("5Eb", gidorian, pump(3, fillarray(3, 3, 2, 2, 7))))
endif


	endin
	start("SCORE")

	instr ROUTE
kdyn	= lfo(1, gkbeatf, 3)*lfa(1, gkbeatf/16)
chnset(.5+lfo(.45, gkbeatf/4), "delirium.fb")
chnset(gkbeats/randomi:k(2, 12, gkbeatf/4), "delirium.time")
routemeout("juliet", "delirium")

getmeout("repuck", 1-(kdyn * golin(1, 75, 0)))
getmeout("juliet", 1-(kdyn * golin(1, 75, 0)))
	endin
	start("ROUTE")
