	instr score

gkpulse	= 70

amen(16, $f)
madcow(8, $pp)
	
	endin
	start("score")

	
	instr route

flingj3("amen", pump(16, fillarray(1, 3, 7, 2, 3, 1))*100, lfse(.25, 1, gkbeatf/8)) 
flingj3("amen", pump(24, fillarray(1, 3, 7, 2, 3, 1))*100, .95) 

flingj("madcow", pump(24, fillarray(1, 3, 7, 2, 3, 1))*100, .95) 
getmeout("madcow")

	endin
	start("route")

