
	start("Score")

	instr Score

kdyn = abs(lfo:k($ff, 1/beats(8)))

if (eu(5, 6, 16) == 1) then
	e("Juliet",
	beats(.5),
	sc(gilydian, 1, circle(3, fillarray(1, 2, 6)) + circle(4, fillarray(5, 7))),
	$mf)
endif

chnset(abs(lfo(15, 1/measures(8))), "vdel.time")
chnset(.85, "vdel.fb")
;routemeout("Juliet", "vdel", .95)

;getmeout("Puck")
getmeout("Juliet")		

	endin
