	start("Score")

set_tempo(105)

	instr Score

kch = circle(1, fillarray(0, -2, 0, 5))
kchoth = circle(1, fillarray(0, 0, 1))

kdyn1	= abs(lfo($ff, 1/circle(4, fillarray(beats(4), beats(2)))))

if (eu(7, 12, 8) == 1) then
	bi("rePuck",
	beats(.5) * kdyn1,
	scall("4C", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("4C", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
endif

kdyn2	= abs(lfo($ff, 1/circle(1, fillarray(beats(8), beats(4)))))

krel	= lfo(.95, beats(1), 3) * abs(lfo(.95, beats(32)))

if (eu(6, 12, 6) == 1) then
	bi("Puck",
	beats(1) * kdyn1 + krel,
	scall("3G", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, circle(1, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch),
	kdyn2)
elseif (eu(3, 12, 16) == 1) then
	bi("Juliet",
	beats(5) * kdyn2,
	scall("4Bb", giionian, circle(4, fillarray(1, 3, 2, 3, 1, 3, 2, 5))),
	scall("4Bb", giionian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch + kchoth),
	$mf * krel)
endif

	endin


	start("Percus")

	instr Percus

kch = abs(lfo($mf, beats(2)))

if (eu(6, 12, 16) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Hats/Analog/XF_HatAna01.wav",
	.15,
	kch)
elseif (eu(6, 16, 16) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Hats/Analog/XF_HatAna04.wav",
	.15,
	kch * .25)
elseif (eu(6, 16, 8) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Hats/Analog/XF_HatAna05.wav",
	.55,
	kch * .25)
elseif (eu(12, 24, 2) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Hats/Analog/XF_HatAna11.wav",
	.25,
	$fff)
endif


if (eu(8, 16, 4) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Kicks/Analog Kicks/XF_Kick_A_003.wav",
	.5,
	$mf,
	random:k(.05, 1))
elseif (eu(11, 24, 2) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Kicks/Analog Kicks/XF_Kick_A_003.wav",
	.25,
	$mp,
	random:k(.05, 1))
elseif (eu(7, 16, 6) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Kicks/Analog Kicks/XF_Kick_A_009.wav",
	1,
	$mf,
	random:k(.05, 1))
endif

	endin


	start("Route")
	instr Route
;routemeout("Juliet", "delirium", golin(0, 55, .55))

getmeout("rePuck", .75)
getmeout("Puck", .5)
getmeout("Juliet", .5)

chnset(.15 + $abslfo(.45'.05), "Moog.q")
chnset(250 + $abslfo(15$k'.005), "Moog.freq")
routemeout("Drum", "Moog", .75)

	endin
