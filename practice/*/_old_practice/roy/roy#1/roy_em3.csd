	instr score

gkpulse = 120-(pump(12, fillarray(0, 90, 0, 0))*cosseg(1, 75, 0))

kvar pump 12, fillarray(24, 16, 24, 24, 32)

kshin lfh 1

if gkmo_top5 > 0 then
	shinobi(kvar/3, $ff)
endif

$when(eujo(5, 8, kvar))
	eva(oncegen(girot2), "repuck",
	gkbeats*$once(1, 1, 1, 1, 24),
	accent(3, $fff),
	gilikearev$atk(5),
	step("1F", giquarter, pump(8, fillarray(1, 3, 5, 7, 3, 1, 3, 9, 10)))*$once(1, .25, .5, 1),
	step("4F", giquarter, pump(8, fillarray(1, 3, 5, 7, 3, 1, 3, 9, 10)))*$once(.25, .5, 1))
endif

$when(gkroy_top4)
	eva("burd",
	gkbeats*12,
	accent(3, $mf),
	giclassic,
	step("1F", giquarter, 12+$once(1, 3, 5, 7, 3, 1, 3, 9, 10)))
	gkroy_top4 = 0
endif

	endin
	start("score")


	
	instr ruote

	flingj3("shinobi", gkbeatms, portk(limit(gkmo_top1, .5, .995), 550$ms), portk(limit(gkmo_top1, 0, 1), 625$ms))

	flingj3("repuck", gkbeatms, portk(limit(gkmo_top1, .5, .995), 150$ms), portk(limit(gkmo_top1, 0, 1), 125$ms))


	moogj("repuck", ntof("3F")+portk(gkmo_top2*1250, 125$ms), .85, portk(limit(gkmo_top2, 0, 1), 125$ms))
	ringj3("repuck", gkbeatf/portk(limit(gkmo_top3, 1, 12), 125$ms), portk(limit(gkmo_top3, .75, 1), 145$ms), giasine, portk(limit(gkmo_top3, 0, 1), 125$ms))

	moogj("burd", ntof("2F")+portk(gkmo_top4*650, 125$ms), .85, portk(limit(gkmo_top4, 0, 1), 125$ms))

	endin
	start("ruote")



