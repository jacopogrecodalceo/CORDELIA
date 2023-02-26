	instr score

gkpulse	= 65 + (randomh:k(-25.5, 15.5, gkbeatf*4)*comeforme(35))

$if eu(9, 16, 32, "heart") $then
	e("wendy",
	gkbeats/lfse(1, 24, gkbeatf*512),
	$fff,
	step("1F", gilocrian, pump(24, fillarray(1, 2, 3, -2, 1, 4))))

	e("cascadexp",
	gkbeats/lfse(1, 24, gkbeatf*512),
	$fff,
	step("1F", gilocrian, pump(24, fillarray(1, 2, 3, -2, 1, 4))))
endif

$if eu(3, 16, 32, "heart", 1) $then
	e("wendy",
	gkbeats/lfse(1, 12, gkbeatf*256),
	$fff,
	step("2F", gilocrian, pump(24, fillarray(1, 2, 3, -2, 1, 4)), int(random(-5, 5))))

	e("cascadexp",
	gkbeats/lfse(1, 12, gkbeatf*256),
	$pp,
	step("4F", gilocrian, pump(24, fillarray(1, 2, 3, -2, 1, 4)), int(random(-5, 5))))
endif

$if eu(5, 16, 32, "heart", 3) $then
	e("wendy",
	gkbeats/lfse(1, 24, gkbeatf*256),
	$f,
	step("3C", gilocrian, pump(24, fillarray(1, 2, 3, -2, 1, 4))))
endif

$if eu(4, 16, 32, "heart", 4) $then
	e("wendy",
	gkbeats/lfse(1, 12, gkbeatf*512),
	$mf,
	step("4F", gilocrian, pump(24, fillarray(1, 2, 3, -2, 1, 4))))

	e("cascadexp",
	gkbeats/lfse(1, 12, gkbeatf*512),
	$p,
	step("3F", gilocrian, pump(24, fillarray(1, 2, 3, -2, 1, 4))))

endif

	endin
	start("score")

	instr route

getmeout("wendy")
getmeout("cascadexp")

flingue("wendy", a(portk(gkbeats/16, gkbeats/32)), lfse(.25, .95, gkbeatf/8), .15)

	endin
	start("route")
