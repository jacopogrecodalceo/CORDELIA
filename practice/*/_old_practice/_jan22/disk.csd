	instr score

gkpulse = 75

kch	lfse 1, 15, .05

if (eu(6, 16, 8, "heart") == 1) then
	eva_disk("ixland",
	gkbeats/1.15,
	$ff,
	giclassicr,
	step("2G", giwhole, kch),
	step("3F", giwhole, kch),
	step("3C", giwhole, kch))
endif

if (eu(6, 16, 8, "heart", 2) == 1) then
	eva_disk("bee",
	gkbeats*2,
	$ff,
	giclassic,
	step("4F", giwhole, kch),
	step("4C", giwhole, kch))
endif

	endin
	start("score")

	instr route

getmeout("ixland")
getmeout("bee")
flingj3("ixland", pump(24, fillarray(0, 5, 2.5, 15)), .95)
flingj2("ixland", pump(12, fillarray(0, 5, 2.5, 15)), .95)

	endin
	start("route")
