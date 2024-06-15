	instr score

gkpulse	= 125 - rall(8, 115)

kch	= pump(1, fillarray(0, -2, 0, 3))
kchoth	= pump(1, fillarray(0, 0, 1))

if	(eu(7, 12, 16, "heart") == 1) then
	eva("aaron",
	gkbeats,
	$ff,
	step("4C", gidorian, pump(8, fillarray(1, 3, 2, 3))),
	step("4C", gidorian, pump(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch))
endif

if	(eu(6, 12, 16, "heart") == 1) then
	eva("wendy",
	gkbeats,
	$ff,
	step("3G", gidorian, pump(8, fillarray(1, 3, 2, 3))),
	step("3G", gidorian, pump(1, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch))
elseif	(eu(3, 12, 32, "heart") == 1) then
	eva("aaron",
	gkbeats*2,
	$ff,
	step("4Bb", giionian, pump(4, fillarray(1, 3, 2, 3, 1, 3, 2, 5))),
	step("4Bb", giionian, pump(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch + kchoth))
endif

getmeout("wendy")
getmeout("cascade")
getmeout("aaron")

	endin
	start("score")
