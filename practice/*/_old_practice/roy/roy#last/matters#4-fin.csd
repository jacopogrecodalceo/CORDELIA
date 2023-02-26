	instr score

gkpulse	= 60

$if	eu(3, 16, 32, "heart") $then
	eva("bebois",
	gkbeats/2,
	accent(3, $mf),
	once(fillarray(giclassic, -gieclassic, gimirror)),
	step("4D", giwhole, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))),
	step("4C", giwhole, pump(48, fillarray(1, 2, 7, 1, 3, 7)), pump(random:k(0, 4), (fillarray(0, -2)))))
endif

maison(4, $ff)
nasa(6, $p)

dance(pump(32, fillarray(8, 9, 4, 12, 16))*2, $mf)
contempo(pump(24, fillarray(2, 8, 9, 4, 12, 16))*2, $f)


zzz1(1.25, $mf)
zzz2(1.25, $mf)
zzz3(1, $mf)
zzz4(2.5, $mf)
drum(16, $mp)
zzz5(1, $mf)

zzz6(24, $mf)
zzz6(16, $mf)
zzz6(12, $mf)


;gkgain = 1
;gkgain fadeaway 15
;gkgain comeforme 15

$if eu(6, 8, 16, "heart") $then
	eva("alonefr",
	gkbeats,
	$f,
	once(fillarray(gieclassic, giclassic)),
	step("0B", giwhole, pump(32, fillarray(1, 2, 7, 3, 5, 4, 6, 9)))*once(fillarray(.25, 13, 1, 9, 3, 4)))
endif

	endin
	start("score")

	instr route

getmeout("alonefr")

	endin
	start("route")



	instr route

k1 k follow2(limit(a(gkmo_top1), 0, 1), .05, .05)
k2 k follow2(limit(a(gkmo_top2), 0, 1), .05, .05)
k3 k follow2(limit(a(gkmo_top3), 0, 1), .05, .05)
k4 k follow2(limit(a(gkmo_top4), 0, 1), .05, .05)
k5 k follow2(limit(a(gkmo_top5), 0, 1), .05, .05)
k6 k follow2(limit(a(gkmo_top6), 0, 1), .05, .05)

getmeout("zzz1", k1)

getmeout("zzz2", k2)
getmeout("contempo", k2)

getmeout("dance", k3)
getmeout("zzz3", k3)
getmeout("maison", k3)

getmeout("zzz4", k4)
getmeout("nasa", k4)
getmeout("drum", k4)

getmeout("zzz5", k5)
flingj3("bebois", oscili:k(gkbeatms*2, gkbeatf/lfse(12, 24, gkbeatf/12), gikazan), lfh(1)*.5, k5)
moogj("bebois", 25+oscili:k(15$k, gkbeatf*lfse(4, 16, gkbeatf/16), giclassic), lfh(1), k5)

getmeout("zzz6", k6)

getmeout("alonefr")

	endin
	start("route")

