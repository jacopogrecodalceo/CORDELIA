giexpmed	ftgen 0, 0, 16385, 5, .00015, 13000, .15, 3000, 1, 384, 1

	instr score

kphasor	= (chnget:k("heart")*32)%1
printk .25, kphasor
krall	= tab(kphasor, giexpmed)*35
printk .25, krall

gkpulse	= 135 - krall


$if	eu(5, 8, 16, "heart") $then
	e("wendy",
	gkbeats*2,
	$f,
	step("1B", gidim, pump(15, fillarray(7, 7, 5, 4, 1, 5, 3, 1))))
endif


	endin
	start("score")

	instr route
routemeout("wendy", "moog")
	endin
	start("route")
