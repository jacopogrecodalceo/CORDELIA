	start("Score")

set_tempo(90)

	instr Score

kdyn = abs(lfo:k($fff, 1/beats(8)))

if (eu(3, 8, 9) == 1) then
	bi("Puck",
	beats(5),
	scall("3F", gioriental, 1, circle(16, fillarray(4, 3, 2)) + circle(1, fillarray(0, -2))),
	scall("3Eb", giromanian, 1, circle(16, fillarray(1, 3, 2)) + circle(1, fillarray(2, -3))),
	kdyn)
endif

;chnset(1250, "Moog.freq")

chnset(.05, "delirium.fb")
routemeout("Puck", "delirium", .65)
getmeout("rePuck")
getmeout("Puck")

	endin
