	instr score

gkpulse	= 95 + lfo(15, gkbeatf/2, 3)

if (eu(7, 15, 4, "heart") == 1) then
	e("witches",
	random(1, 2),
	$f,
	gieclassic,
	step("4Eb", gidorian, once(fillarray(1, 5, 3, 7))),
	step("3Bb", giaeolian, once(fillarray(1, 4, 3, 2))))
endif

chnset(int(lfse(1, 5, gkbeatf/64)), "witches.mod")
chnset(lfse(3, 15, gkbeatf/32), "witches.ndx")

	endin
	start("score")

	instr route

getmeout("witches")

	endin
	start("route")
