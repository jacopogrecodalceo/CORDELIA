	instr score

idur	= 95
k1	go .05, idur, .95

k2	go 100, idur, 90

gkpulse	= 125-(((chnget:k("heart")*16)%1)>k1 ? k2 : 0)

if (eu(14, 16, 16, "heart") == 1) then
	eva("noij",
	gkbeats*2,
	accent(3, $f),
	gilikearev$atk(5),
	step("0D", gilocrian, pump(4, fillarray(1, 3, -1, 2))-1)*once(fillarray(2, 4, 2)),
	step("1D", gilocrian, pump(2, fillarray(1, 3, -1, 2)))*once(fillarray(1, 2, 4)))
	
	ilen = gichiseq_len
	gkchiseq_sonvs pump 32, fillarray(0, random:k(0, ilen))
endif

chiseq(2, $pppp)


	endin
	start("score")

	instr route
distj1("noij", .25, .85+lfo(.15, 2))
ringhj2("chiseq", 16, lfh(8)*.5)
ringhj3("alghed", 24, lfh(9)*.5)

lofj("chiseq", gkchiseq_sonvs/8, .95, 10, gitri, lfh(2))
getmeout("aaron")
	endin
	start("route")
