instr P1

  set_tempo(155)
  
  set_scale("whole")
  set_root("4Eb")

  S1 = "ffff"
  S2 = "8000"

  hextriad(S2,
	"Puck",
	p3,
	in_scale(0, 1),
	in_scale(0, 0),
	in_scale(0, -3),
	ampdbfs(-12),
	1,
	random(.05, 1.5))

endin
