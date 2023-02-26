	instr Score

kch = pump(1, fillarray(0, -2, 0, 5))
kchoth = pump(1, fillarray(0, 0, 1))

kdyn1	= lfa($f, pump(4, fillarray(gkbeatf/4, gkbeatf/2)))

gkpulse = 125 

if (eu(7, 12, 8, "heart") == 1) then
	bi("repuck",
	gkbeats/2 * kdyn1,
	scall("4C", gidorian, pump(8, fillarray(1, 3, 2, 3))),
	scall("4C", gidorian, pump(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
elseif (eu(11, 12, 8, "heart") == 1) then
	bi("repuck",
	gkbeats/2 * kdyn1,
	scall("3C", gidorian, pump(8, fillarray(1, 3, 2, 3)) + 7),
	scall("3C", gidorian, pump(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
endif

kdyn2	= lfa($ff, 1/pump(1, fillarray(gkbeatf/8, gkbeatf/4)))

krel	= lfo(.95, gkbeatf, 3) * lfa(.95, gkbeatf/32)

if (eu(6, 12, 16, "heart") == 1) then
	bi("puck",
	gkbeats * kdyn1 + krel,
	scall("3G", gidorian, pump(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, pump(1, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch),
	kdyn2)
elseif (eu(3, 12, 16, "heart") == 1) then
	bi("juliet",
	gkbeats*5 * kdyn2,
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



	instr Percus

kch = lfa($mf, gkbeatf/2)

if (eu(6, 12, 32, "heart") == 1) then
	edrum("HH/closed/brilliant/01a.wav",
	.15,
	kch)
elseif (eu(6, 16, 32, "heart") == 1) then
	edrum("HH/closed/brilliant/01b.wav",
	.15,
	kch * .25)
elseif (eu(6, 16, 8, "heart") == 1) then
	edrum("HH/closed/brilliant/02a.wav",
	.55,
	kch * .25)
elseif (eu(12, 24, 2, "heart") == 1) then
	edrum("HH/closed/brilliant/02b.wav",
	.25,
	$fff)
endif

if (eu(7, 16, 8, "heart") == 1) then
	edrum("kick/XF_Kick_A_003.wav",
	.5,
	$mf,
	random:k(.05, 1))
elseif (eu(11, 24, 4, "heart") == 1) then
	edrum("kick/XF_Kick_A_003.wav",
	.25,
	$mp,
	random:k(.05, 1))
elseif (eu(9, 16, 6, "heart") == 1) then
	edrum("kick/XF_Kick_A_009.wav",
	1,
	$mf,
	random:k(.05, 1))
elseif (eu(4, 16, 16, "heart") == 1) then
	edrum("kick/XF_Kick_A_011.wav",
	1,
	$f,
	random:k(.05, 1))
endif
	endin
	start("Percus")


	instr Route
routemeout("juliet", "delirium")

getmeout("repuck")
getmeout("puck")
getmeout("juliet")

chnset(.15 + lfa(.45, .5), "moog.q")
chnset(250 + lfa(15$k, .05), "moog.freq")
;routemeout("drum", "moog", .75)

getmeout("drum", .95)


	endin
	start("Route")

	start("go")
