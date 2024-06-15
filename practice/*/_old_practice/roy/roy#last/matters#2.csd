	instr score

gkpulse = 50;-k(follow2(limit(a(gkmo_top5), 0, 1), .025, 3))*35

elair(2, $p)
elair(.5, $p)

cril(11, $mp)
cril(16, $mp)

elground(.75, $ppp)

ift init gipentamin
kch pump 8, fillarray(0, -1, 0, 5, 1, 3)

kdyn = 48+lfh(2)*32


$if gkroy_top1 $then

	eva("armagain",
	gkbeats/random:k(3, 4),
	$fff,
	giclassic,
	16, 24)

	gkroy_top1 = 0
endif
gkgain comeforme 5
	endin
	start("score")

	
	instr route

;stringj("elground", 25+k(follow2(limit(a(gkmo_top1), 0, 1), .025, 1)*1500), .5, k(follow2(limit(a(gkmo_top1), 0, 1), .025, 3)))

;stringj("elpark", 9500-k(follow2(limit(a(gkmo_top2), 0, 1), .025, 1)*9000), .65, k(follow2(limit(a(gkmo_top2), 0, 1), .025, 3)))
;getmeout("elair", k(follow2(limit(a(gkmo_top3), 0, 1), .005, .005)))

flingj("elair", k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1))*gkbeatms, .5*k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1)), k(follow2(limit(a(gkmo_top3), 0, 1), .005, .005))*6)
flingj("elground", k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1))*gkbeatms, .15*k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1)), k(follow2(limit(a(gkmo_top3), 0, 1), .005, .005)))

getmeout("armagain", k(follow2(limit(a(gkmo_top1), 0, 1), .005, .005)))
flingj("armagain", k(follow2(limit(a(gkmo_top1), 0, 1), .025, 1))*gkbeatms, .35, k(follow2(limit(a(gkmo_top1), 0, 1), .005, .005)))

moogj("valle", 25+k(follow2(limit(a(gkmo_top2), 0, 1), .15, .15))*5$k, .5, k(follow2(limit(a(gkmo_top2), 0, 1), .005, .125)))

getmeout("cril", k(follow2(limit(a(gkmo_top4), 0, 1), .005, .005)))

;getmeout("alonefr")
;getmeout("alone", k(follow2(limit(a(gkmo_top3), 0, 1), .005, .005)))
	endin
	start("route")

