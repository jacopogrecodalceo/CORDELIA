	instr score

k1	= 1

gkpulse	= 170-(((chnget:k("heart")*8)%1)>k1 ? 70 : 0)

if (eu(8, 16, 24, "heart") == 1) then
	e("fim",
	gkbeats*accent(4, 1, .25),
	accent(8, $mf),
	gieclassic,
	1203*once(fillarray(.5, 2, .5, .5, .5, .6, .7, .8)),
	500*once(fillarray(.5, .2, .5, .4, .5, 6, .7, 8)))
endif
	endin
	start("score")

	instr route
getmeout("wendj")
getmeout("fim")
getmeout("alone")
	endin
	start("route")
