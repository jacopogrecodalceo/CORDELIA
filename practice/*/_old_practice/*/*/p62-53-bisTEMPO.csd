	start("Score")
	instr Score

kch = circle(1, fillarray(0, -2, 0, 5))
kchoth = circle(1, fillarray(0, 0, 1))

kdyn1	= abs(lfo($f, 1/circle(4, fillarray(beats(4), beats(2)))))

gk_tempo = 105 + ((lfo(25, beatsk(1), 3) + lfo(-50, beatsk(2), 3)) * abs(lfo(1, 1/45)))

printk(1, gk_tempo)

if (eu(7, 12, 8) == 1) then
	bi("rePuck",
	beatsk(.5) * kdyn1,
	scall("4C", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("4C", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
elseif (eu(11, 12, 8) == 1) then
	bi("rePuck",
	beatsk(2) * kdyn1,
	scall("3C", gidorian, circle(8, fillarray(1, 3, 2, 3)) + 7),
	scall("3C", gidorian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7)) + kch),
	kdyn1)
endif

kdyn2	= abs(lfo($ff, 1/circle(1, fillarray(beats(8), beats(4)))))

krel	= lfo(.95, beats(1), 3) * abs(lfo(.95, beats(32)))

if (eu(6, 12, 8) == 1) then
	bi("Puck",
	beatsk(1) * kdyn1 + krel,
	scall("3G", gidorian, circle(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, circle(1, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch),
	kdyn2)
elseif (eu(3, 12, 16) == 1) then
	bi("Juliet",
	beatsk(5) * kdyn2,
	scall("4Bb", giionian, circle(4, fillarray(1, 3, 2, 3, 1, 3, 2, 5))),
	scall("4Bb", giionian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch + kchoth),
	$mf * krel)
elseif (eu(6, 12, 16) == 1) then
	bi("Puck",
	beatsk(5) * kdyn2,
	scall("4Bb", giionian, circle(4, fillarray(1, 3, 2, 3, 1, 3, 2, 5))),
	scall("4Bb", giionian, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7)) + kch),
	$f)
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

if (eu(7, 16, 4) == 1) then
	edrum("/Volumes/petit elements di j/sonvs_reseau-beta/bibliothèque/Deadmau5 Xfer/Kicks/Analog Kicks/XF_Kick_A_003.wav",
	.5,
	$mf,
	random:k(.05, 1))
elseif (eu(11, 24, 2) == 1) then
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
;routemeout("Juliet", "delirium", golin(0, 55, .55))

getmeout("rePuck", .75)
getmeout("Puck")
getmeout("Juliet")

chnset(.15 + $abslfo(.45'.5), "Moog.q")
chnset(250 + $abslfo(15$k'.05), "Moog.freq")
;routemeout("Drum", "Moog", .75)

getmeout("Drum", .95)


	endin
