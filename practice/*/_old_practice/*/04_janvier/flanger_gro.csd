	instr score

gkpulse	= 65 + randomh:k(-25.5, 15.5, gkbeatf*4)


$if eu(4, 16, 16, "heart", 4) $then
	e("aaron",
	gkbeats/lfse(1, 24, gkbeatf*512),
	$p,
	step("4F", gilocrian, pump(24, fillarray(1, 2, 7, -2, 1, 4))))

	e("cascadexp",
	gkbeats/lfse(1, 24, gkbeatf*512),
	$p,
	step("3F", gilocrian, pump(24, fillarray(1, 2, 3, -2, 1, 4))))

endif

	endin
	start("score")

	instr route

flingue("aaron", a(portk(gkbeats/2, gkbeats/32)), lfse(.25, .95, gkbeatf/2))

flingue("cascadexp", a(portk(gkbeats/2, gkbeats/12)), lfse(.25, .95, gkbeatf/8))

	endin
	start("route")
