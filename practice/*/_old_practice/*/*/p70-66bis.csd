	start("Score")
	instr Score

k1	= $pp + $abslfo($f'1/beatsk(4))

if (eu(9, 16, circle(8, fillarray(12, 16, 17, 16))) == 1) then
	tri("rePuck",
	beatsk(.15),
	scall("4C", giminor, circle(1, fillarray(1, 4, 3, 4))),
	scall("4C", gidorian, circle(1, fillarray(1, 4, 3, 7))+1),
	scall("4C", giminor, circle(16, fillarray(6, -1, 1, 4))+9),
	k1)
endif

if (eu(9, 16, circle(8, fillarray(16, 16, 17, 16))) == 1) then
	e("Puck",
	beatsk(circle(8, fillarray(.25, .5, .15, .35))),
	scall("4C", gidorian, circle(2, fillarray(5, 5, 6, 7))),
	k1)
endif

if (eu(9, 16, circle(8, fillarray(16, 16, 17, 16))) == 1) then
	e("Juliet",
	beatsk(circle(8, fillarray(.25, .5, .15, .35))),
	scall("4C", gidorian, circle(2, fillarray(5, 5, 6, 7))),
	k1)
endif

	endin


	start("Percus")
	instr Percus

kch = abs(lfo($f, beats(2)))

if (eu(6, 12, circle(4, fillarray(16, 16*2, 4, 36))) == 1) then
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

if (eu(7, 16, circle(4, fillarray(4, 8, 6, 4))) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Kicks/Analog Kicks/XF_Kick_A_003.wav",
	.5,
	$ff,
	random:k(.05, 1))
elseif (eu(11, 24, circle(8, fillarray(4, 8, 6, 4))) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Kicks/Analog Kicks/XF_Kick_A_003.wav",
	.25,
	$mp,
	random:k(.05, 1))
elseif (eu(9, 16, 6) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Kicks/Analog Kicks/XF_Kick_A_009.wav",
	1,
	$mf,
	random:k(.05, 1))
elseif (eu(4, 16, 8) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Kicks/Analog Kicks/XF_Kick_A_011.wav",
	1,
	$f,
	random:k(.05, 1))
endif
	endin


	start("Route")

	instr Route

gkpulse = 115

chnset(.5, "delirium.fb")

routemeout("Juliet", "delirium", lfo(1, 1/beatsk(16), 3))

getmeout("rePuck")
getmeout("Puck")
getmeout("Drum")

	endin

