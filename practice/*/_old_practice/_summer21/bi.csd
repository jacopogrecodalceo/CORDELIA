	instr score

gkpulse	= 150-timeh(16)

gkfim_detune	= 1.995
gkfim_var	= 0 

k1	pump 4, fillarray(0, -5)
k2	= 8

k3	lfse 1, .15, gkbeatf/32

k4	= 64

$if	eu(3, 8, 32, "heart") $then
	p(2, "xylo",
	gkbeats*k3*once(fillarray(0, 0, 0, 0, 0, 8*k3))*2,
	accent(3, $f),
	gieclassic$atk(5),
	step("4G", giwhole, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)),
	step("3E", gikumoi, pump(k2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)))
endif

$if	eu(3, 8, 32, "heart") $then
	p(-3, "fim",
	gkbeats*k3*once(fillarray(1, 1, once(fillarray(0, 2, 0, 1)), 1, 1, 4*k3))*1.5,
	accent(3, $mp),
	gieclassic,
	step("4G", giwhole, pump(k2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)),
	step("3E", gikumoi, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)))
endif

$if	eu(3, 8, 32, "heart") $then
	p(-3, "cascade",
	gkbeats*k3*once(fillarray(1, 1, once(fillarray(0, 2, 0, 1)), 1, 1, 4*k3))*2,
	accent(3, $mp),
	once(fillarray(giclassic, giclassic, gimirror)),
	step("4G", giwhole, pump(k2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)),
	step("3E", gikumoi, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)))
endif

	ninfa(pump(8, fillarray(4, 0, 1, 0, 2, 0, 1, 0)), $pppp)

	endin
	start("score")

	
	instr route
getmeout("xylo")
getmeout("ninfa")
getmeout("fim")
getmeout("cascade")
	endin
	start("route")

