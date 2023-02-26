	instr score

gkpulse	= 105

krel	lfse .25, 16, gkbeatf/16
ktrig 	= 0
$if	eu(7, 12, 32, "heart") $then
	ktrig = 1

	kfq int ktrig
	e("alone",
	gkbeats*random:k(.5, 8),
	random:k(.015, .5),
	intv(ktrig))
endif
	endin
	start("score")

	instr route
getmeout("alone", .15)
	endin
	start("route")
