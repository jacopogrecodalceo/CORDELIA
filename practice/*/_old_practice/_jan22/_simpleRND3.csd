	instr score

gkpulse	= 50

kch pump 8, fillarray(8, 16, 24, 32)

kch	+= randomh:k(-1, 1, gkbeatf)
kch	*= 1

$if hex("8912", abs(kch)) $then
	eva("algo2",
	gkbeats*2,
	accenth(4, $f),
	giclassic,
	pump(64, fillarray(4, 3, 6.35, 2, 6, 2, 6.35, 4))*2)
endif

$if hex("8912", abs(kch)/4) $then
	eva("ixland",
	gkbeats*4,
	accent(4, $p),
	giclassic,
	50*pump(64, fillarray(4, 3, 6.35, 2, 6, 2, 6.35, 4))*int(random:k(1, 3)))
endif
	endin
	start("score")

	instr route

pitchj("algo2", pump(16, fillarray(18/8, 4, 3, 4/3)), .85)
getmeout("algo2")
getmeout("ixland")
pitchj2("ixland", pump(16, fillarray(18/8, 4, 3, 4/3))/2, .75)

	endin
	start("route")
