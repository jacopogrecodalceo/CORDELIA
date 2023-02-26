set_tempo(65)

instr P1

  set_scale("whole")
  set_root("4D")
/*
  if (phs(1) == 0) then
  	iran = random(0, 4)
  	if (iran < 1) then
		set_root("4C")
	elseif (iran > 1 && iran < 2) then
		set_root("4Eb")
	elseif (iran > 2 && iran < 3) then
		set_root("3Bb")
	elseif (iran > 3 && iran < 4) then
		set_root("4D")
	endif
  endif
*/
  
  
  irel1 = xoscb(2, array(3.15, 9.5))
  irel2 = xoscb(3, array(3.15, 9.5))
  irel3 = xoscb(4, array(3.15, 9.5))


  hexplay("f0f4",
    "Puck", 
    p3-(p3*3/irel1),
    in_scale(0, xoscb(3, array(0, -5, -4, 0, 1, -4))),
    ampdbfs(p4 % 16 == 0 ? -12 : random(-12, -16)),
    1,
    random(.5, irel1))

  hexplay("f8f4",
    "Puck", 
    p3-(p3*3/irel2),
    in_scale(0, xoscb(16, array(2, -3, 0))),
    ampdbfs(p4 % 16 == 0 ? -12 : random(-12, -16)),
    1,
    random(.5, irel2))

  hexplay("ff34ff",
    "Puck", 
    p3-(p3*3/irel3),
    in_scale(-1, xoscb(16, array(-2, 0, -2))),
    ampdbfs(p4 % 16 == 0 ? -12 : random(-12, -16)),
    1,
    random(.5, irel3))

endin
