	instr score

gkpulse	= 90
gkeuarm_onset int go(3, 90, 24)
gkeuarm_pulse int go(24, 120, 128)

$if eu(5, 8, 8, "heart") $then
	eva("euarm",
	gkbeats*2,
	$pp,
	once(fillarray(giclassic, gikazan)),
	step("3B", gilocrian, pump(8, fillarray(1, 2, 7))))
endif

	endin
	start("score")

	
	instr route

flingj2("euarm", gkbeatms/gkeuarm_onset, .5)

	endin
	start("route")

