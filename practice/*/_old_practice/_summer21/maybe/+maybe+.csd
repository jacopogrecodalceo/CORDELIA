	instr score

gkpulse	= 130

gkfim_detune	= 2
gkfim_var	line 0, 25, 1 

gk1	pump 4, fillarray(0, -5)
k2	= 8

k3	cosseg .85, 7.5, .15, 15, .75
k4	= 64

$if	eu(8, 8, 32, "heart") $then
	e("fim",
	gkbeats*k3*once(fillarray(1, 1, 1, 1, 1, 8*k3)),
	accent(3, $fff),
	gieclassic$atk(5),
	step("3G", giwhole, pump(k2, fillarray(1, 3, 7, 1, 2, 7)), gk1)*once(fillarray(.25, .5, 1)),
	step("4E", giminor, pump(k2, fillarray(1, 3, 7, 1, 2, 7)), gk1)*once(fillarray(.25, .5, 1)))
endif

$if	eu(8, 8, 32, "heart") $then
	e("burd",
	gkbeats*k3*once(fillarray(1, 1, 1, 1, 1, 8*k3)),
	accent(3, $ff),
	giclassic$atk(5),
	step("5G", giwhole, pump(k2, fillarray(1, 3, 7, 1, 2, 7)), gk1)*once(fillarray(.25, .5, 1)),
	step("3G", giminor, pump(k2, fillarray(1, 3, 7, 1, 2, 7)), gk1)*once(fillarray(.25, .5, 1)),
	step("1E", giminor, pump(k2, fillarray(1, 3, 7, 1, 2, 7)), gk1)*once(fillarray(.25, .5, 1)))
endif
	endin
	start("score")

	
	instr route
getmeout("fim")
moogj("fim", step("1G", giwhole, pump(32, fillarray(1, 3, 7, 1, 2, 7)), gk1), .95, .65) 
flingj("fim", portk(pump(32, fillarray(1, 3, 7, 1, 2, 7)), 15$ms), .5)
getmeout("wendj")

flingj("burd", portk(pump(12, fillarray(1, 3, 7, 1, 2, 7)), 15$ms), .75)

	endin
	start("route")

