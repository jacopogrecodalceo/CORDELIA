	instr Score

gkpulse	= 125 + lfo(55, .5, 3)

if (eu(1, 2, 1, "heart") == 1) then
	e("witches",
	gkbeats/8,
	$p,
	195 + lfo:k(35, 85, 3),
	150)
endif

givemekick(3, 4, 4, "heart", 1, $f, )
	endin
	start("Score")

	instr Route

chnset(.95, "delirium.fb")
chnset(gkbeats/3, "delirium.time")

hardduckmeout("witches", "inlets", .0015, .0015)

;routemeout("inlets", "delirium", abs(lfo(1, .5, .15)))
;routemeout("repuck", "moog")
;routemeout("repuck", "delirium")
;routemeout("puck", "moog")

;routemeout("puck", "delirium")

;getmeout("repuck")
;getmeout("puck")
;getmeout("snug")
;getmeout("inlets")

chnset(.75, "moog.q")
chnset(125, "moog.freq")
routemeout("drum", "moog")

	endin
	start("Route")
