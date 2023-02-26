	instr Score

kch	= pump(1, fillarray(0, -2, 0, 5))
kchoth	= pump(1, fillarray(0, 0, 1))

kdyn1	= lfa($f, pump(4, fillarray(gkbeatf/4, gkbeatf/8)))

gkpulse = 75 + lfo(15, gkbeatf, 3)
gkbreath = 55

if (eu(7, 12, 8, "heart") == 1) then
	bi("repuck",
	gkbeats/2 * kdyn1,
	scall("4C", gidorian, pump(8, fillarray(1, 3, 2, 3))),
	scall("4C", gidorian, pump(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
elseif (eu(11, 12, 8, "heart") == 1) then
	bi("repuck",
	gkbeats*2 * kdyn1,
	scall("3C", gidorian, pump(8, fillarray(1, 3, 2, 3)) + 7),
	scall("3C", gidorian, pump(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
endif

kdyn2	= lfa($ff, pump(1, fillarray(gkbeatf/8, gkbeatf/4)))

krel	= lfo(.95, gkbeatf, 3) * lfa(.95, gkbeatf/32)

if (eu(6, 12, 8, "heart") == 1) then
	bi("puck",
	gkbeats * kdyn1 + krel,
	scall("3G", gidorian, pump(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, pump(1, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch),
	kdyn2)
elseif (eu(3, 12, 16, "heart") == 1) then
	bi("fairest",
	gkbeatf*5 * kdyn2,
	scall("4Bb", giionian, pump(4, fillarray(1, 3, 2, 3, 1, 3, 2, 5))),
	scall("4Bb", giionian, pump(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch + kchoth),
	$mf * krel)
elseif (eu(6, 12, 16, "heart") == 1) then
	bi("puck",
	gkbeats*5 * kdyn2,
	scall("4Bb", giionian, pump(4, fillarray(1, 3, 2, 3, 1, 3, 2, 5))),
	scall("4Bb", giionian, pump(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch),
	$f)
endif

	endin
	start("Score")


	instr Percu

givemekick(7, 16, 8, "lungs", 3, .5, $mf)
givemekick(11, 24, 4, "lungs", 33, .25, $mp)
givemekick(9, 16, 6, "lungs", 39, 1, $mf)
givemekick(4, 16, 16, "lungs", 11, 1, $f)

	endin
	start("Percu")


	instr Route
chnset(.95, "delirium.fb")
chnset(gkblows/(random:k(2, 8)), "delirium.time")
routemeout("repuck", "delirium", jump(gkbeatf/16))

getmeout("deliriumson")
getmeout("deliriumdaughter")

followmeout("puck", "drum", .05, .5)

followmeout("repuck", "drum", .05, .5)

followmeout("fairest", "drum", .05, .05)

getmeout("drum")
	endin
	start("Route")

