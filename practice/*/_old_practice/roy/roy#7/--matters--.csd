	instr score

gkpulse = 50-k(follow2(limit(a(gkmo_top5), 0, 1), .025, 3))*35

elair(2, $ff)
ift init gipentamin
kch pump 8, fillarray(0, -1, 0, 5, 1, 3)

kdyn = 6+lfh(2)*32

$if hex("8", 3) $then
	eva("noij",
	gkbeats*4,
	pump(12, fillarray($ff, $mf, $mf, $mf))/kdyn,
	giatri,
	step("4Eb", ift, 5+pump(4, fillarray(1, 3))),
	step("3C", ift, kch+2+pump(4, fillarray(1, 3, 1, 6))),
	step("1G", ift, kch+pump(4, fillarray(1, 3, 1, 6))))
endif

	endin
	start("score")

	
	instr route

moogj("elair", 25+k(follow2(limit(a(gkmo_top1), 0, 1), .025, 1)*1500), .75, k(follow2(limit(a(gkmo_top1), 0, 1), .025, 3)))

rezj("elair", 9500-k(follow2(limit(a(gkmo_top2), 0, 1), .025, 1)*9000), .5, k(follow2(limit(a(gkmo_top2), 0, 1), .025, 3)))

ringj3("elair", k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1))*25, .35*k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1)), gisotrap, k(follow2(limit(a(gkmo_top3), 0, 1), .025, 3)))

flingj("elair", k(follow2(limit(a(gkmo_top4), 0, 1), .025, 1))*gkbeatms/2, .15*k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1)), k(follow2(limit(a(gkmo_top4), 0, 1), .025, 3)))

getmeout("noij", lfh(6)*(1-follow2(limit(a(gkmo_top5), 0, 1), .025, 3)))

	endin
	start("route")

