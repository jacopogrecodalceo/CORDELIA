	instr score

gkpulse almost 35

elacid(1, $mf)
elground(.5, $ff*4)

elpot(.5, $ff)
bois2(2, $ff*12)
bois(4, $ff*12)

ift init gipentamin
kch pump 8, fillarray(0, -1, 0, 5, 1, 3)

kdyn = 32+lfh(2)*32

if gkroy_top1 == 1 then
	
	eva("beboo", "dmitri",
	gkbeats*random(2, .125),
	accent(5, $f),
	gired$atk(5),
	random(25, 95)*$once(1, 1, 4))

	gkroy_top1 = 0
endif

if gkroy_top3 == 1 then

	eva("meli",
	gkbeats*random(1, .25),
	accent(5, $f),
	giclassic$atk(5),
	step("4F", giminor, $once(1, 3, 5, 7)))

	gkmeli_sonvs += 1
	gkmeli_sonvs = gkmeli_sonvs%gimeli_len

	gkroy_top3 = 0

endif

elterre(pump(8, fillarray(8, 4, 2, 6)), $ff)

	endin
	start("score")


	
	instr route

flingj("bois", k(follow2(limit(a(gkmo_top4), 0, 1), .025, .025))*gkbeatms/12, .15*k(follow2(limit(a(gkmo_top4), 0, 1), .025, .025)), k(follow2(limit(a(gkmo_top4), 0, 1), .025, .025)))
flingj("bois2", k(follow2(limit(a(gkmo_top4), 0, 1), .025, .025))*gkbeatms/24, .05*k(follow2(limit(a(gkmo_top4), 0, 1), .025, .025)), k(follow2(limit(a(gkmo_top4), 0, 1), .025, 3)))

getmeout("elacid", k(follow2(limit(a(gkmo_top2), 0, 1), .005, .005)))
getmeout("elground", k(follow2(limit(a(gkmo_top2), 0, 1), .005, .005)))


getmeout("elterre", k(follow2(limit(a(gkmo_top3), 0, 1), .005, .025)))

getmeout("beboo")
getmeout("meli")
getmeout("dmitri", 1/8)

getmeout("elterre", 1-portk(gkmo_topsum, .5))

	endin
	start("route")

