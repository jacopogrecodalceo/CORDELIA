	start("Score")

	instr Score

kdyn	= abs(lfo($fff, beats(.5), 4))

if (eu(12, 32, 4) == 1) then
	e("Puck",
	$med,
	in_scale(0, circle(5, fillarray(1, 2, 6)) + circle(3, fillarray(-5, -7))),
	kdyn)
endif

if (eu(12, 15, 2) == 1) then
	e("rePuck",
	$long,
	in_scale(1, circle(5, fillarray(1, 2, 6)) + circle(3, fillarray(-5, -7))),
	kdyn)
endif


chnset(350 + lfo(50, 1/measures(8)), "Moog.freq")
routemeout("Puck", "Moog")

routemeout("rePuck", "delirium", .5)


routemeout("Puck", "delirium", linseg:k(0, 35, .15))
	
	endin
