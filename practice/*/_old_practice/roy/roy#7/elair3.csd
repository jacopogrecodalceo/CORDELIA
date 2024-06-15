	instr score

gkpulse = 50

elground(.5, $f)
elground(1, $mf)

	endin
	start("score")

	
	instr route

kch pump 8, fillarray(6, 16, 32, 4, 6)

k35h("elground", portk(step("6G", gilocrian, 7+pump(kch, fillarray(1, 3, 2, 3, 3, 7, 9, 1, 1))), 5$ms), .5)
k35h("elground", portk(step("5G", gilocrian, 2+pump(kch, fillarray(2, 3, 3, 7, 9, 1, 1))), .5)
;stringj("elground", step("3G", gilocrian, pump(kch, fillarray(1, 3, 2, 3, 3, 7, 9, 1, 1))), .5)
;stringj("elground", step("4G", gilocrian, pump(kch/2, fillarray(1, 3, 2, 3, 3, 7, 9, 1, 1))), .5)

	endin
	start("route")

