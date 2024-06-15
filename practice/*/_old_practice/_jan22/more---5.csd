	instr score

gkpulse	= 140

kch	pump 8, fillarray(16, 12, 32, 24)

kfreq	phasor .35

$if  hex("8001a0001000", kch) $then
	eva("ixland",
	gkbeats,
	$f,
	giclassic,
	pump(9, fillarray(300, 400, 200, 50))+200*table:k(kfreq+.25, giclassic, 1),
	pump(4, fillarray(300, 400, 200))+200*table:k(kfreq, giclassic, 1))
endif


$if  hex("008001a00010", kch/2) $then
	eva("ixland",
	gkbeats*4,
	$f,
	giclassic,
	pump(9, fillarray(300, 400, 200, 50))+300*table:k(kfreq+.25, giclassic, 1),
	pump(4, fillarray(300, 400, 200))+300*table:k(kfreq, giclassic, 1))
endif
;givemekick(4, 4, 16, "heart", 3, .05, $ff)
;givemekick(3, 8, 16, "heart", 11, .5, $ff)

;givemednb(16, $f, "heart")
	endin
	start("score")

	instr route

getmeout("fairest")


;followdrum("puck")

getmeout("ixland")
getmeout("repuck", lfo(1, gkbeatf + lfa(gkbeatf, gkbeatf/24), 3))
	endin
	start("route")

