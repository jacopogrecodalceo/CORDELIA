	instr Score
klfo	= lfo(1, gkbeat_f/8, 3)

gkpulse	= 95 + (55*klfo) + lfo(25, gkbeat_f/16)
kdyn	= abs(lfo(gkbeat_s*2, gkbeat_f/4))

kchange = int(lfo(2, gkbeat_f/16, 3)) - int(lfo(2, gkbeat_f/24, 2))

if (eu(5, 16, 8, "Heart") == 1) then
	bi("Fairest",
	gkbeat_s+kdyn,
	scall("3B", gidorian, pulsate(4, fillarray(1, 3, 2) + (7 * int(random:k(0, 1))) + kchange)),
	scall("3B", gidorian, pulsate(2, fillarray(1, 3, 2, 5, 3, 2)+2 + (7 * int(random:k(0, 1))))),
	$ff)
endif

if (eu(5, 16, 8, "Heart") == 1) then
	e("Fairest",
	gkbeat_s,
	scall("4F#", gidorian, pulsate(4, fillarray(1, 3, 2, int(random:k(5, 7)), 3, int(random:k(1, 3)))+2)),
	$f)
endif

if (eu(5, 16, 8, "Heart") == 1) then
	e("rePuck",
	gkbeat_s,
	scall("3F#", gidorian, pulsate(4, fillarray(1, 3, 2, int(random:k(5, 7)), 3, int(random:k(1, 3)))+2 + kchange*2)),
	$mf)
endif

kch	= $p + abs(lfo($f, gkbeat_f/8))

;gkbreath	= lfo(1, gkbeat_f/2, 3) == 0 ? 95 : gkpulse
gkbreath	= 95 + lfo(5, gkblow_f/4)

if (eu(14, 16, 12, "Lungs") == 1) then
	e("Puck",
	gkblow_s,
	scall("4D", gidorian, breathe(8, fillarray(1, 2))),
	$pp)
endif

if (eu(14, 16, 12, "Lungs") == 1) then
	bi("Puck",
	gkblow_s,
	scall("4D", gidorian, breathe(8, fillarray(1, 2))),
	scall("4C", gimajor, breathe(8, fillarray(1, 2)+5)),
	$p)
endif

givemekick(4, 4, 16, "Lungs", 11, .05, $mf)
givemekick(4, 4, 12, "Lungs", 13, .05, $mp)
givemekick(4, 6, 12, "Lungs", 3, .05, $p)


	endin
	start("Score")

	instr Route
chnset(.95 + randomi:k(-.5, .035, gkbeat_f), "Delirium.fb")
chnset(gkbeat_s/int(random:k(8, 16)), "Delirium.time")
;routemeout("Fairest", "Delirium", $ff)
routemeout("rePuck", "Delirium", $ff)

routemeout("rePuck", "Bribes", lfo(1, 1/beatsk(4), 3))
routemeout("Puck", "Twinkle", lfo(1, 1/beatsk(4), 3))

;followmeout("Fairest", "Drum", .015, .05)
followmeout("rePuck", "Drum", .015, .05)
getmeout("Drum")
getmeout("Puck", $ff)
getmeout("Fairest", lfo($ff, gkblow_f*sine(8, gkbeat_f/4), 3))
	endin
	start("Route")
