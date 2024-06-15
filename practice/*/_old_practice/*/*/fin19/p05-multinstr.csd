instr P1

  set_tempo(125)

  if (phsm(2) == 0) then
	set_root("3C#-35")
	set_scale("aeolian")
  elseif (phsm(2) == .5) then
	set_root("3F+15")	
	set_scale("pentamaj")
  endif

  hexplay("f2f8",
    "StJacques", 
    p3,
    in_scale(-1, p4 % 5),
    ampdbfs(p4 % 8 == 0 ? -5 : random(-9, -12)),
    3,
    p4 % 8 == 0 ? 3 : random(.05, .5))

endin

instr P1
endin
