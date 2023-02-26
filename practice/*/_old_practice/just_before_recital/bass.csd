	instr score

idur	= 95
k1	go .05, idur, .95

k2	go 100, idur, 90

gkpulse	= 125-(((chnget:k("heart")*16)%1)>k1 ? k2 : 0)

if (eu(16, 16, 8, "heart") == 1) then
	eva(oncegen(girot6), "repuck",
	gkbeats*once(fillarray(.5, .5, .5, 4)),
	accent(3, $f),
	giclassic$atk(5),
	step("3D", gilocrian, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("3D", gilocrian, pump(2, fillarray(1, 3, -1, 2))-1)*once(fillarray(1, 2, 4, 2)),
	step("3D", gilocrian, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
	
	ilen = gichiseq_len
	gkchiseq_sonvs pump 32, fillarray(0, random:k(0, ilen))
endif

if (eu(12, 16, 16, "heart") == 1) then
	eva("sunij",
	gkbeats*once(fillarray(1, 1, 4)),
	accent(3, $f, $ppp),
	gilikearev$atk(1),
	step("3D", gilocrian, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("4D", gilocrian, pump(2, fillarray(1, 3, -1, 2))-1)*once(fillarray(1, 2, 4, 2)),
	step("2D", gilocrian, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
endif

if (eu(8, 16, 4, "heart") == 1) then
	eva("aaron",
	gkbeats*once(fillarray(.25, .25, .25, 8)),
	accent(3, $pp),
	giclassic$atk(5),
	step("3D", gilocrian, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("3D", gilocrian, pump(2, fillarray(1, 3, -1, 2))-1)*once(fillarray(1, 2, 4, 2)),
	step("3D", gilocrian, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))

	ilen = gialghed_len
	gkchiseq_sonvs random 0, ilen

endif

chiseq(8, $mf)
alghed(8, $mp)

	endin
	start("score")

	instr route
distj1("repuck", .25, .85+lfo(.15, 2))
ringhj2("chiseq", 16, lfh(8)*.5)
ringhj3("alghed", 24, lfh(9)*.5)

getmeout("sunij")
getmeout("aaron")
	endin
	start("route")
