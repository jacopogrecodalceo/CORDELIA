	instr score

gkpulse = 25+k(follow2(limit(a(gkmo_top5), 0, 1), .025, 3))*5

kground abs lfa(gkbeatf/8)
elground(.5, $ff*kground)
bois2(2, $fff*2)
bois(4, $fff*2)

ift init gipentamin
kch pump 8, fillarray(0, -1, 0, 5, 1, 3)

kdyn = 32+lfh(2)*32

if gkroy_top1 == 1 then
	


	gknoinput_sonvs += 1
	gknoinput_sonvs = gknoinput_sonvs%ginoinput_len

	gkroy_top1 = 0
endif

if gkroy_top3 == 1 then


	gkmeli_sonvs += 1
	gkmeli_sonvs = gkmeli_sonvs%gimeli_len

	gkroy_top3 = 0

endif

elterre(4, $ff)

	endin
	start("score")


	
	instr route

moogj("elground", 25+k(follow2(limit(a(gkmo_top1), 0, 1), .025, 1)*1500), .75, k(follow2(limit(a(gkmo_top1), 0, 1), .025, 3)))
flingj("bois", k(follow2(limit(a(gkmo_top4), 0, 1), .025, 1))*gkbeatms/32, .65*k(follow2(limit(a(gkmo_top4), 0, 1), .025, 1)), k(follow2(limit(a(gkmo_top4), 0, 1), .025, 3)))

flingj("elground", 5+k(follow2(limit(a(gkmo_top2), 0, 1), .025, 1)*25), .5, k(follow2(limit(a(gkmo_top2), 0, 1), .05, 3)))

ringj("elground", k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1))*25, .35*k(follow2(limit(a(gkmo_top3), 0, 1), .025, 1)), giasine, k(follow2(limit(a(gkmo_top3), 0, 1), .025, 3)))

flingj("bois2", k(follow2(limit(a(gkmo_top4), 0, 1), .025, 1))*gkbeatms/32, .65*k(follow2(limit(a(gkmo_top4), 0, 1), .025, 1)), k(follow2(limit(a(gkmo_top4), 0, 1), .025, 3)))

getmeout("noij", lfh(6)*(1-k(follow2(limit(a(gkmo_top5), 0, 1), .025, 3))))
getmeout("beboo")
getmeout("meli")
getmeout("noinput")

getmeout("elterre", lfh(6)*(1-k(follow2(limit(a(gkmo_topsum), 0, 1), .025, 3))))

	endin
	start("route")

