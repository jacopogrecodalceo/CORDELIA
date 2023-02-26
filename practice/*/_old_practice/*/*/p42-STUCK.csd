	start("Score")

	instr Score

kdyn	= abs(lfo($fff, beats(8), 3))

if (eu(12, 32, 4) == 1) then
	e("Puck",
	$med,
	in_scale(0, circle(5, fillarray(1, 2, 6)) + circle(3, fillarray(-5, -7))),
	$f)
endif

if (eu(12, 15, 2) == 1) then
	e("rePuck",
	$long,
	in_scale(1, circle(5, fillarray(1, 2, 6)) + circle(3, fillarray(-5, -7))),
	$ff)
endif


chnset(1250 + lfo(500, 1/measures(4)), "Moog.freq")
routemeout("Puck", "Moog")

chnset(.75, "delirium.fb")

routemeout("rePuck", "delirium", kdyn)
;routemeout("Puck", "delirium", abs(lfo:k(.15, 1/measures(4))))

;xmeout("rePuck", "Puck", 35)
	
	endin
