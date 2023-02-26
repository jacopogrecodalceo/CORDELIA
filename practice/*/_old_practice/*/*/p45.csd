	start("Score")

	instr Score

kdyn = abs(lfo:k($ff, 1/beats(8)))

if (eu(9, 16, 3) == 1) then
	e("Puck",
	beats(3),
	in_scale(-1, circle(5, fillarray(1, 2, 6)) + circle(3, fillarray(5, 7))),
	kdyn)
endif

if (eu(15, 16, 6) == 1) then
	e("Puck",
	beats(3),
	in_scale(-1, circle(3, fillarray(1, 2, 6)) + circle(3, fillarray(5, 7))),
	kdyn)
endif

kgroove2 = abs(lfo:k($mf, 1/beats(4)))

if (eu(19, 32, 6) == 1) then
	e("Puck",
	beats(5),
	in_scale(-1, circle(5, fillarray(1, 2, 6)) + circle(2, fillarray(5, 7))),
	kgroove2)
endif

;chnset(.905, "delirium.fb")

;routemeout("Puck", "delirium", .5)

getmeout("Puck")		

	endin

gamme("dorian")
