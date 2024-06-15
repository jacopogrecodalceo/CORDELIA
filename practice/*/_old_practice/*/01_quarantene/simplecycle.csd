	instr score

if (eu(11, 12, 16, "heart") == 1) then
	e("repuck",
	gkbeats,
	pump(pump(4, fillarray(32, 48, 16)), fillarray($fff, $mf)),
	scall("3G", gilocrian, lfia(12, gkbeatf*16)),
	scall("3G", gilocrian, lfia(12, gkbeatf*32)+1))
endif

if (eu(5, 12, 16, "heart") == 1) then
	e("puck",
	gkbeats*lfpa(.25, 8, gkbeatf/16),
	pump(pump(4, fillarray(32, 48, 16)), fillarray($fff, $mf)),
	scall("4G", gilocrian, lfia(12, gkbeatf*16)),
	scall("4G", gilocrian, lfi(12, gkbeatf*32)+1))
endif

if (eu(5, 12, 2, "heart") == 1) then
	e("fairest",
	gkbeats*8,
	$fff,
	scall("2G", gilocrian, lfia(12, gkbeatf*16)),
	scall("2G", gilocrian, lfi(12, gkbeatf*32)+1))
endif

givemednb(pump(16, fillarray(12, 16)), $fff, "heart")

	endin
	start("score")

	instr route

getmeout("repuck")
getmeout("puck")
followdrum("fairest")


chnset(gkbeats, "delirium.time")
routemeout("drum", "delirium", .5)
routemeout("puck", "delirium")

chnset(lfse(.95, .05, gkbeatf/6), "moog.q")
chnset(1$k + lfia(15, gkbeatf/12)$k, "moog.freq")
routemeout("drum", "moog")

	endin
	start("route")
