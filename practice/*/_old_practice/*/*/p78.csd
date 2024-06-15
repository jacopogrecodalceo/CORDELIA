	instr Score

gkpulse = 105 + lfo(55, gkbeatf/16)

kharm	= pulsate(1, fillarray(0, 1))

if (eu(4, 12, 8, "heart") == 1) then
	tri("Fairest",
	gkbeats*2,
	scall("3G", gilocrian, pulsate(3, fillarray(3, 3, 2, 2, 7) + kharm)),
	scall("3Bb", gidorian, pulsate(3, fillarray(3, 3, 2, 2, 7))),
	scall("3D", gidorian, pulsate(6, fillarray(3, 3, 2, 2, 7))),
	$f)
endif

if (eu(4, 12, 8, "heart") == 1) then
	tri("rePuck",
	gkbeats*4,
	scall("4G", gilocrian, pulsate(3, fillarray(3, 3, 2, 2, 7) + kharm)),
	scall("4Bb", gidorian, pulsate(3, fillarray(3, 3, 2, 2, 7))),
	scall("4D", gidorian, pulsate(6, fillarray(3, 3, 2, 2, 7))),
	$pp)
endif

if (eu(9, 16, 8*2, "heart") == 1) then
	e("Puck",
	gkbeats/4,
	scall("4G", gilocrian, pulsate(7, fillarray(3, 3, 2, 2, 7))),
	$mp)
endif

gkbreath = 125 + lfo(5, gkbeatf/2)
givemekick(4, 4, 12, "lungs", 3, .15, $mf)

	endin
	start("Score")

	instr Route
chnset(.95, "Delirium.fb")
chnset(gkbeats/randomi:k(12, 16, gkbeatf), "Delirium.time")
routemeout("Fairest", "Delirium", $f)

routemeout("Fairest", "Bribes", $mf)
routemeout("Fairest", "Twinkle", $mf)
getmeout("rePuck")
getmeout("Drum")
followmeout("Fairest", "Puck", .005, .05)
softduckmeout("Fairest", "Drum", .005, .05)
	endin
	start("Route")
