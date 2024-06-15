	instr score

gkpulse	= 115 + lfo(55, gkbeatf*4, 3)

$if eu(6, 6, 16, "heart", 4) $then
	e("wendyx",
	gkbeats/4, 
	$fff,
	step("5B", gidorian, pump(8, fillarray(0, 0, 3, 4))),
	step("4G", gidorian, pump(8, fillarray(0, 2, 3, 0))),
	step("3Eb", gidorian, pump(8, fillarray(1, 0, 3, 0))))
endif

	endin
	start("score")

	instr route
chnset(.95, "delirium.fb")
;routemeout("wendyx", "delirium")
	endin
	start("route")
