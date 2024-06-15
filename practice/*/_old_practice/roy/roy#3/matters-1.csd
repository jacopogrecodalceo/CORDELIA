	instr score

;gkpulse = 50+lfo(5, 1/30)
gkpulse = 50+follow2(limit(gkmo_topsum, .025, 3))*7.5

elacid(1, $p)
elair(1, $fff)
elground(.5, $ff)
elpark(.25, $pp)
elwater(.25, $p)
elwind(.5, $pp)

	endin
	start("score")

	
	instr route

getmeout("elpark", follow2(limit(a(gkmo_top1), 0, 1), .025, 3))
getmeout("elground", follow2(limit(a(gkmo_top2), 0, 1), .025, 3))
getmeout("elwater", follow2(limit(a(gkmo_top3), 0, 1), .025, 3))
getmeout("elair", follow2(limit(a(gkmo_top4), 0, 1), .025, 3)*1.5)
getmeout("elwind", follow2(limit(a(gkmo_top5), 0, 1), 1, 5))

	endin
	start("route")

