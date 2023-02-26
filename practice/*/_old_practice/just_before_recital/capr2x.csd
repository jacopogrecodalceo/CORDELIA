	instr score

gkpulse	pump 2, fillarray(120, 90, 100, 70)

printk2 gkpulse

ilen	init gicapr2x_len

$if hex("f18", 8) $then
	gkcapr2x_sonvs once fillarray(0, random:k(0, ilen), 2, 3, 1)
endif

capr2x(8, $mp)
capr2x(4, $mp)

	endin
	start("score")

	instr route

flingjm("capr2x", gkbeatms/5, .5*lfh(8), .5)
flingj("capr2x", gkbeatms, .85*lfh(6), .5)
flingjm("capr2x", gkbeatms*7, .75*lfh(1), .5)

ringhj3("capr2x", 3.5, .5, gihtri, lfh(3)*.5)
	endin
	start("route")

