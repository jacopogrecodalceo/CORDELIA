	instr score

;gkpulse = 50+lfo(5, 1/30)
gkpulse = 50;+k(follow2(limit(a(gkmo_topsum), 0, 1), .025, 3))*3.5

elacid(1, $ppp)
elair(1, $fff)
elground(.5, $ff)
elpark(.25, $pp)
elwater(.25, $p)
elwind(.5, $ppp)

$when(eujo(5, 8, 32))
	eva("tension",
	gkbeats/$once(2, 4, 8, 4, 8)*12,
	accent(3, $ff),
	giclassic,
	$once(2, 4, 8, 4, 8)/2,
	$once(2, 4, 8, 4, 8))
endif
tension(4, $f)
tension(6, $f)

	endin
	start("score")

	
	instr route

getmeout("tension", follow2(limit(a(gkmo_top1), 0, 1), .025, 3)*8)

getmeout("elground", follow2(limit(a(gkmo_top2), 0, 1), .025, 3))

getmeout("elwater", follow2(limit(a(gkmo_top3), 0, 1), .025, 3))

getmeout("elair", follow2(limit(a(gkmo_top4), 0, 1), .025, 3)*1.5)
getmeout("elwind", follow2(limit(a(gkmo_top4), 0, 1), 3, .025))

	endin
	start("route")

