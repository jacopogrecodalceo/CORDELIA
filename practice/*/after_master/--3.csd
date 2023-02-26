	instr score

gkpulse	= 90

kdur lfo 1, .05

$if eu(5, 8, 32, "heart") $then
	eva("ciel", 
	gkbeats,
	accent(5, $ff),
	$once(gired, gigrembo),
	2+kdur,
	8*$once(1, .25, 1, 2, 1))
endif

$if eu(5, 8, 32, "heart") $then
	eva("wutang", 
	gkbeats/2,
	accent(5, $f),
	$once(gired, gigrembo),
	ntof("2C"))
endif

drumhigh(16, $fff)

	endin
	start("score")

	
	instr route

flingj("ciel", gkbeatms*2, .25)
getmeout("wutang")
getmeout("drumhigh")
	endin
	start("route")

