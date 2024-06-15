	start("Score")

set_tempo(175)

	instr Score

Lau("/Users/j/Downloads/Loop Cult - ARACHNE - Sample Pack/LC_ARCHN_drum loops/LC_ARCHN_drum loops full/LC_ARCHN_172_Drum_01_Full.wav", 2, $ff)
if (eu(7, 12, 8) == 1) then
	bi("Puck",
	beats(.5),
	scall("4C", gidorian, 0, circle(8, fillarray(1, 3, 2, 3))),
	scall("4C", gidorian, 0, circle(2, fillarray(3, 2, 5, 4, 3, 2, 5, 7))),
	$f)
endif



kdyn	= abs(lfo($ff, 1/beats(8)))

if (eu(7, 12, 8) == 1) then
	bi("rePuck",
	beats(.5),
	scall("3G", gidorian, 0, circle(8, fillarray(1, 3, 2, 3))),
	scall("3G", gidorian, 0, circle(1, fillarray(3, 2, 5, 4, 3, 2, 5, 7, 3, 2, 5, 7, 3, 2, 5, 7))),
	kdyn)
endif


chnset(50, "K35.freq")
routemeout("Laurence", "Moog")
;routemeout("Laurence", "K35", golin(1, 15, 0))
getmeout("Puck")
getmeout("rePuck")

	endin
