	start("Score")

	instr Score

kdyn = abs(lfo:k($fff, 1/beats(8)))

if (eu(7, 8, 16) == 1) then
	e("rePuck",
	beats(.5),
	scall("3D", gidorian, 0, circle(16, fillarray(1, 2, 3))),
	kdyn)
endif

if (eu(5, 8, 16) == 1) then
	e("rePuck",
	beats(.5),
	scall("3D", gidorian, 0, circle(16, fillarray(1, 2, 4)) + 3),
	(1 - kdyn))
endif

if (eu(3, 8, 16) == 1) then
	e("Puck",
	beats(3),
	scall("3F", gimajor, 1, circle(16, fillarray(4, 3, 2)) + circle(1, fillarray(0, -2))),
	kdyn)
endif

;chnset(1250, "Moog.freq")
;routemeout("rePuck", "Moog")
getmeout("rePuck")
getmeout("Puck")

	endin
