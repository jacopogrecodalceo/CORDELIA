	instr Score

kch = pulsate(1, fillarray(0, -2, 0, 5))
kchoth = pulsate(1, fillarray(0, 0, 1))

kdyn1	= abs(lfo($f, 1/pulsate(4, fillarray(gkbeatf/4, gkbeatf/4))))

gkpulse = 75 + lfo(15, gkbeatf, 3)
gkbreath = 55

if (eu(7, 12, 8, "heart") == 1) then
	bi("rePuck",
	gkbeats/2 * kdyn1,
	scall("4C", gidorian, pulsate(8, fillarray(1, 3, 2, 3))),
	scall("4C", gidorian, pulsate(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
elseif (eu(11, 12, 8, "heart") == 1) then
	bi("rePuck",
	gkbeats*2 * kdyn1,
	scall("3C", gidorian, pulsate(8, fillarray(1, 3, 2, 3)) + 7),
	scall("3C", gidorian, pulsate(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
endif

kdyn2	= abs(lfo($ff, 1/pulsate(1, fillarray(beats(8), beats(4)))))

krel	= lfo(.95, beats(1), 3) * abs(lfo(.95, beats(32)))

if (eu(6, 12, 8, "heart") == 1) then
	bi("Puck",
	gkbeats * kdyn1 + krel,
	scall("3G", gidorian, pulsate(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, pulsate(1, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch),
	kdyn2)
elseif (eu(3, 12, 16, "heart") == 1) then
	bi("Fairest",
	gkbeatf*5 * kdyn2,
	scall("4Bb", giionian, pulsate(4, fillarray(1, 3, 2, 3, 1, 3, 2, 5))),
	scall("4Bb", giionian, pulsate(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch + kchoth),
	$mf * krel)
elseif (eu(6, 12, 16, "heart") == 1) then
	bi("Puck",
	gkbeats*5 * kdyn2,
	scall("4Bb", giionian, pulsate(4, fillarray(1, 3, 2, 3, 1, 3, 2, 5))),
	scall("4Bb", giionian, pulsate(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch),
	$f)
endif

	endin
	start("Score")


	instr Percus

givemekick(7, 16, 8, "Lungs", 3, .5, $mf)
givemekick(11, 24, 4, "Lungs", 33, .25, $mp)
givemekick(9, 16, 6, "Lungs", 39, 1, $mf)
givemekick(4, 16, 16, "Lungs", 11, 1, $f)

	endin
	start("Percus")


	instr Route
chnset(.95, "Delirium.fb")
chnset(gkblows/(random:k(2, 8)), "Delirium.time")
routemeout("rePuck", "Delirium", jump(gkbeatf/16))

getmeout("Deliriumson")
getmeout("Deliriumdaughter")

followmeout("Puck", "Drum", .05, .5)

followmeout("rePuck", "Drum", .05, .5)

followmeout("Fairest", "Drum", .05, .05)

getmeout("Drum")
	endin
	start("Route")

