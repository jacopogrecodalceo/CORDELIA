	instr score

gkpulse	= 120

kch	pump 1, fillarray(0, 1, 3, 2)

kfreq	phasor .35

if (eu(5, 16, 16, "heart") == 1) then
	eva("puck",
	gkbeats,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($fff, $mf)),
	giclassic,
	pump(9, fillarray(300, 400, 200, 50))+200*table:k(kfreq+.25, giclassic, 1),
	pump(4, fillarray(300, 400, 200))+200*table:k(kfreq, giclassic, 1))
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

