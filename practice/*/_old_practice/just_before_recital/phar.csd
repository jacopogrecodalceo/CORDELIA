	instr score

gkpulse	pump 2, fillarray(120, 90, 100, 70)

printk2 gkpulse

ilen	init gipharm_len

$if hex("f18", 8) $then
	gkpharm_sonvs once fillarray(0, random:k(0, ilen), 2, 3, 1)
endif

pharm(4, $mp)
pharm(8, $mp)

	endin
	start("score")

	instr route

flingjm("pharm", gkbeatms/3, .5*lfh(4), .5)
flingjm("pharm", gkbeatms, .85*lfh(3), .5)
flingjm("pharm", gkbeatms*1.5, .75*lfh(1), .5)

ringhj2("pharm", 16, .85, giclassic, lfh(3)*.5)
	endin
	start("route")

