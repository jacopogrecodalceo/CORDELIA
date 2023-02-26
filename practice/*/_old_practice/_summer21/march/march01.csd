	instr score

gkpulse	= 70

amen(16, $p)
ninfa(16, $mf)
	
gkamen_dur pump 8, 1/fillarray(1, 16, 16, 16)
gkamen_time = 4

gkninfa_dur = 1/16
gkninfa_time = 4

$if	eu(3, 8, 32, "heart") $then
	p(3, "xylo",
	gkbeats*once(fillarray(4, 0, 0, 0, 0, 4)),
	accent(3, $f),
	gieclassic$atk(5),
	step("4G", giwhole, pump(16, fillarray(1, 3, 7, 1, 2, 7)))*once(fillarray(.25, .5, 1)),
	step("3E", gikumoi, pump(8, fillarray(1, 3, 7, 1, 2, 7)))*once(fillarray(.25, .5, 1)))
endif

	endin
	start("score")

	
	instr route

flingj3("amen", pump(16, fillarray(1, 3, 7, 2, 3, 1))*100, lfse(.25, 1, gkbeatf/8)) 
flingj3("amen", pump(24, fillarray(1, 3, 7, 2, 3, 1))*100, .95) 

flingj("ninfa", pump(24, fillarray(1, 3, 7, 2, 3, 1))*100, .95) 
getmeout("ninfa")
getmeout("xylo")
	endin
	start("route")

