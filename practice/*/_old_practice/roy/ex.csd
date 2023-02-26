	instr score

gkpulse	= 90

k1	= 1+(2*lfh(2))

kdyn = k(follow2(limit(a(gkmo_top1), 0, 1), .025, .125))


kch = k(follow2(limit(a(gkmo_top1), 0, 1), .025, .125))*12

$if eujo(3+kch, 16, 32) $then
	eva("ixland",
	(gkbeats/6),
	accent(3)*kdyn,
	gieclassic,
	step("4Bb", gipentamaj, pump(24, fillarray(1, random:k(1, 8), 3, random:k(1, 8))))*$once(.25, .5, 1))
endif
	endin
	start("score")

	instr route

kdyn = k(follow2(limit(a(gkmo_top1), 0, 1), .025, .125))

;ringhj3("mario1", pump(1, fillarray(1, 2, 4)), .35, giasquare)
ringhj("amen", pump(8, fillarray(1, .5, 1, .65)), 0, giasquare)
distj2("wutang", 1)
moogj("mario1", 25+(pump(12, fillarray(2, 4, 6, 8, 1, .5))$k)*kdyn, .75)
k35h("ixland", pump(8, fillarray(2, 4, 6, 8, 1, .5))$k, .35)

	endin
	start("route")

