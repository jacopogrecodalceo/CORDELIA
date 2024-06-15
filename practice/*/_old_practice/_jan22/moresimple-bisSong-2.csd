	instr score

gkpulse	= 120

kch	pump 1, fillarray(0, 1, 3, 2)

if (eu(16, 16, 16, "heart") == 1) then
	eva("puck",
	gkbeats/2,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($fff, $mf)),
	giclassic,
	step("4C", gimajor, -2),
	step("4C", gimajor, 1),
	step("4C", gimajor, 2+kch))
endif

if (eu(16, 16, 8, "heart") == 1) then
	eva("repuck",
	gkbeats,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($fff, $mf)),
	giclassic,
	step("5C", gimajor, -2),
	step("5C", gimajor, 1),
	step("5C", gimajor, 2+kch+7))
endif

if (eu(3, 16, 8, "heart") == 1) then
	eva("fairest",
	gkbeats*8,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($ff, $mp)),
	giclassic,
	step("4C", gimajor, 2+kch+7))
endif

;givemekick(4, 4, 16, "heart", 3, .05, $ff)
;givemekick(3, 8, 16, "heart", 11, .5, $ff)

;givemednb(16, $f, "heart")
	endin
	start("score")

	instr route

getmeout("fairest")


;followdrum("puck")

getmeout("puck")
getmeout("repuck", lfo(1, gkbeatf + lfa(gkbeatf, gkbeatf/24), 3))
	endin
	start("route")

