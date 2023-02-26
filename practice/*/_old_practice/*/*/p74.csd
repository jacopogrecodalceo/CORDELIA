	instr Score
klfo	= lfo(1, 1/beatsk(4), 3)

gkpulse	= 95 + (55*klfo) + lfo(25, 1/beatsk(8))
kdyn	= abs(lfo(beatsk(2), 1/beatsk(4)))

kchange = int(lfo(2, 1/beatsk(16), 3)) - int(lfo(2, 1/beatsk(24), 2))

if (eu(5, 16, 8) == 1) then
	bi("Fairest",
	beatsk(1)+kdyn,
	scall("3B", gidorian, circle(4, fillarray(1, 3, 2) + (7 * int(random:k(0, 1))) + kchange)),
	scall("3B", gidorian, circle(2, fillarray(1, 3, 2, 5, 3, 2)+2 + (7 * int(random:k(0, 1))))),
	$ff)
endif

if (eu(5, 16, 8) == 1) then
	e("Fairest",
	beatsk(2),
	scall("4F#", gidorian, circle(4, fillarray(1, 3, 2, int(random:k(5, 7)), 3, int(random:k(1, 3)))+2)),
	$f)
endif

if (eu(5, 16, 8) == 1) then
	e("rePuck",
	beatsk(2),
	scall("3F#", gidorian, circle(4, fillarray(1, 3, 2, int(random:k(5, 7)), 3, int(random:k(1, 3)))+2 + kchange*2)),
	$mf)
endif

kch	= $p + abs(lfo($f, 1/beats(8)))

k1	= 8 + (4*klfo)

if (eu(16, 16, k1) == 1) then
	edrum("HH/closed/brilliant/01a.wav",
	.15,
	kch)
elseif (eu(12, 16, 4) == 1) then
	edrum("HH/closed/brilliant/01b.wav",
	.25,
	kch/4)
endif

	endin
	start("Score")

	instr Route
chnset(.95, "Delirium.fb")
chnset(beatsk(1/int(randomh:k(4, 8, .5))), "Delirium.time")
;routemeout("rePuck", "Delirium")

;routemeout("Fairest", "Bribes", lfo(1, 1/beatsk(4), 3))
;routemeout("Fairest", "Twinkle", lfo(1, 1/beatsk(4), 3))

;softduckmeout("Fairest", "Drum", .015, .045)
;getmeout("Drum")
getmeout("Fairest")
	endin
	start("Route")
