	instr score

gkpulse = 50;-k(follow2(limit(a(gkmo_top5), 0, 1), .025, 3))*35

gkgain = .75

elair(2, $p)
elair(.5, $p)

cril(24, $mf)
cril(16, $mf)

elground(.25, $mf)

ift init gipentamin
kch pump 8, fillarray(0, -1, 0, 5, 1, 3)

kdyn = 48+lfh(2)*32

$if gkroy_top1 $then

	eva("armagain",
	gkbeats/3,
	$fff,
	giclassic,
	16, 24)

	gkroy_top1 = 0
endif



$if hex("82a9", 32) $then
	eva("dmitrif",
	gkbeats,
	accent(4),
	giclassic,
	step("0Ab", ift, 3))
endif

$if eujo(5, 8, 8, 1) $then
	eva("dmitrif",
	gkbeats/2,
	accent(3),
	giclassic,
	step("1Ab", ift, 3))
endif

kocta init 1

$if gkroy_top2 $then

if random:k(1, 2) > 1 then
	kocta = 1
else
	kocta = 6
endif
	eva("alonefr",
	gkbeats/4,
	$mf,
	giclassic,
	step("3D", ift, random:k(1, 9))*kocta)

	gkroy_top2 = 0
endif

valle(pump(8, fillarray(16, 8, 16, 14)), $f)
valle(6, $f)

	endin
	start("score")

	
	instr route

;stringj("elground", 25+k(follow2(limit(a(gkmo_top1), 0, 1), .025, 1)*1500), .5, k(follow2(limit(a(gkmo_top1), 0, 1), .025, 3)))

;stringj("elpark", 9500-k(follow2(limit(a(gkmo_top2), 0, 1), .025, 1)*9000), .65, k(follow2(limit(a(gkmo_top2), 0, 1), .025, 3)))
;getmeout("elair", k(follow2(limit(a(gkmo_top3), 0, 1), .005, .005)))

flingj("elair", k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1))*gkbeatms, .5*k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1)), k(follow2(limit(a(gkmo_top3), 0, 1), .005, .005))*6)
flingj("elground", k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1))*gkbeatms, .15*k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1)), k(follow2(limit(a(gkmo_top3), 0, 1), .005, .005)))

getmeout("noij", lfh(6)*(1-follow2(limit(a(gkmo_topsum), 0, 1), .025, 3)))

getmeout("armagain", k(follow2(limit(a(gkmo_top1), 0, 1), .005, .005)))
flingj("armagain", k(follow2(limit(a(gkmo_top1), 0, 1), .025, 1))*gkbeatms, .35, k(follow2(limit(a(gkmo_top1), 0, 1), .005, .005)))

moogj("valle", 25+k(follow2(limit(a(gkmo_top2), 0, 1), .15, .15))*5$k, .5, k(follow2(limit(a(gkmo_top2), 0, 1), .005, .125)))

getmeout("cril", k(follow2(limit(a(gkmo_top4), 0, 1), .005, .005)))
moogj("dmitrif", 35)
getmeout("alonefr")
;getmeout("alone", k(follow2(limit(a(gkmo_top3), 0, 1), .005, .005)))
	endin
	start("route")

