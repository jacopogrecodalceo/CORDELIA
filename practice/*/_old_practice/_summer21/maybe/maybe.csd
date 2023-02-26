	instr score

gkpulse	= 130

gkfim_detune	= 2
gkfim_var	= 0 

k1	pump 4, fillarray(0, -5)
k2	= 8

k3	cosseg .25, 15, .75
k4	= 64

$if	eu(7, 8, 32, "heart") $then
	p(-3, "fim",
	gkbeats*k3*once(fillarray(1, 1, 1, 1, 1, 4*k3)),
	accent(3, $fff),
	gieclassic$atk(5),
	step("3G", gimajor, pump(k2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)),
	step("4E", giminor, pump(k2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)))
endif

$if	eu(7, 8, 32, "heart", 3) $then
	p(3, "burd",
	gkbeats*k3*once(fillarray(1, 1, 1, 1, 1, 4*k3)),
	accent(3, $fff),
	gieclassic$atk(5),
	step("4G", gimajor, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)),
	step("3E", giminor, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)))
endif

$if	eu(7, 8, 32, "heart", 1) $then
	e("wendj",
	gkbeats*k3*once(fillarray(0, 2, 0, 2, 0, 8*k3))/2,
	accent(3, $p),
	gieclassic$atk(5),
	step("4G", gipentamaj, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)),
	step("4E", gipentamin, pump(k2*2, fillarray(1, 3, 7, 1, 2, 7)), k1)*once(fillarray(.25, .5, 1)))
endif

	endin
	start("score")

	
	instr route
getmeout("burd")
getmeout("fim")
getmeout("wendj")
	endin
	start("route")

