	instr score

gkpulse = 50-k(follow2(limit(a(gkmo_topsum), 0, 1), .025, 3))

$when(eujo(3, 8, 8))
	eva("fairest3",
	gkbeats*12,
	accent(3, $f)/$once(1, 2, 3, 4),
	$once(giatri, gidiocle),
	step("2G", giminor, $once(1, 2, 7, 1, 3, 5)))
endif

elacid(.25, $pp)
elair(1, $ff)
elground(.5, $ff)
elpark(.25, $pp)
elwater(.5, $p)
elwind(1, $ppp)

gkgain fadeaway 15

	endin
	start("score")

	
	instr route

getmeout("elpark", follow2(limit(a(gkmo_top4), 0, 1), .025, 3))
getmeout("bois2", follow2(limit(a(gkmo_top4), 0, 1), .025, 3)*4)

getmeout("elair", follow2(limit(a(gkmo_top3), 0, 1), .025, 3))

getmeout("elground", follow2(limit(a(gkmo_top2), 0, 1), .025, 3))

getmeout("fairest3", follow2(limit(a(gkmo_topsum), 0, 1), .5, 9))



	endin
	start("route")

