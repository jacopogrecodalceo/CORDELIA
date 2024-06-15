	instr score

gkpulse	= 50+randomi:k(0, 20, .05)

amen(pump(4, fillarray(12, 8, 16, 8)), $f)

gkamen_dur cosseg 1, 5, .25

$if	eu(3, 8, 32, "heart") $then
	eva("xylo",
	gkbeats*once(fillarray(4, 0, 0, 0, 0, 4)),
	accent(3, $f),
	gieclassic$atk(5),
	step("4G", giwhole, pump(16, fillarray(1, 3, 7, 1, 2, 7)))*once(fillarray(.25, .5, 1)),
	step("3E", gikumoi, pump(8, fillarray(1, 3, 7, 1, 2, 7)))*once(fillarray(.25, .5, 1)))
endif	

	endin
	start("score")

	
	instr route

flingj3("amen", pump(16, fillarray(1, 3, 7, 2, 3, 1))*gkbeatms, .95) 
flingj3("amen", pump(24, fillarray(1, 3, 7, 2, 3, 1))*gkbeatms, .95) 

flingj("xylo", pump(24, fillarray(1, 3, 7, 2, 3, 1))*10, .95) 
getmeout("xylo")

	endin
	start("route")

