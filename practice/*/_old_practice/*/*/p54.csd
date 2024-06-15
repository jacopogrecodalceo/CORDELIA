
	instr Turn
gkdyn1	= abs(lfo($ppp, 1/circle(4, fillarray(beats(4), beats(2)))))
gkdyn2	= abs(lfo($ppp, 1/circle(1, fillarray(beats(8), beats(4)))))

;getmeout("rePuck")
getmeout("Puck")

start("Turn")

	endin

	instr Score

if (eu(7, 12, 4) == 1) then
	bi("rePuck",
	beats(5) * gkdyn1,
	random(500, 1250),
	scall("4C", gidorian, random:k(1, 7)),
	gkdyn1)
endif


if (eu(4, 15, 5) == 1) then
	bi("rePuck",
	beats(.5),
	scall(circleS(1, fillarray("4Eb", "3F", "3G")), gidorian, random(1, 5)),
	scall("4G", gidorian, random(1, 5)),
	gkdyn2)
endif

if (eu(3, 10, 4) == 1) then
	e("BD",
	beats(.5),
	1,
	.95)
endif

	endin

	instr Maybe
if (eu(1, 16, 4) == 1) then
    turnoff2("Score", 0, 1)
    schedulek("Score", ksmps / sr, -1)
endif
	endin

	start("Maybe")


	instr Rebecca

a1	poscil	p5, p4 + random:i(-.05, .05), giTri
a2	poscil	p5, p4 + random:i(-.05, .05), giTri



	outs a1, a2

	endin

