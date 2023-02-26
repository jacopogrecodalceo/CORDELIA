	instr Score

gkpulse	= 135

if (eu(14, 16, 16, "heart") == 1) then
	e("supercluster",
	gkbeats*lfse(8, 16, gkbeatf*128),
	$fff,
	step("3C", giquarter, pump(32, fillarray(1, 12))),
	step("2C", giquarter, pump(32, fillarray(1, 12))),
	step("3C", giquarter, pump(32, fillarray(1, 12, 11, 12))))
endif

if (eu(2, 16, 16, "heart") == 1) then
	e("witches",
	gkbeats*8,
	$fff,
	step("1A", giquarter, pump(4, fillarray(1, 11, 3))),
	step("2B", giquarter, pump(4, fillarray(2, 12))))
endif

	endin
	start("Score")

	instr Route
chnset(1, "powerranger.shape")
;getmeout("repuck", hlowa(1, gkbeatf/4, 3))
;routemeout("witches", "moog")
;hardduckmeout("witches", "supercluster", .005, .005)
routemeout("supercluster", "powerranger")
;getmeout("repuck")
getmeout("supercluster")
	endin
	start("Route")
