set_tempo(65)

instr P1

  set_tempo(155)
  set_scale("mixolydian")

  set_root("4C")
  
  irel1 = xoscb(32*4, array(.15, 1.5))
  irel2 = xoscb(32*4, array(.15, 1.5))
  irel3 = xoscb(32*4, array(.15, 3.5))


  hexplay("fff4fff4f0f4ffff",
    "Puck", 
    p3-(p3*3/4),
    in_scale(0, xoscb(32*2, array(0, -5, -4, 0, 1, -4))),
    ampdbfs(p4 % 16 == 0 ? -12 : random(-9, -12)),
    1,
    random(.05, irel1))

  hexplay("f8f4f8f4f7f4ffff",
    "Puck", 
    p3-(p3*3/4),
    in_scale(0, xoscb(32, array(2, -3, 0))),
    fade_out(1, 128) * ampdbfs(p4 % 16 == 0 ? -12 : random(-9, -12)),
    1,
    random(.05, irel2))

  hexplay("ff34ff34ff34fff",
    "Puck", 
    p3-(p3*3/4),
    in_scale(-1, xoscb(32, array(-2, 0, -2))),
    fade_out(1, 128) * ampdbfs(p4 % 16 == 0 ? -12 : random(-9, -12)),
    1,
    random(.05, irel3))

endin

instr P1

  go_tempo(155, 5)
  set_scale("mixolydian")

  set_root("4C")
  
  irel1 = xoscb(32*4, array(.15, 1.5))
  irel2 = xoscb(32*4, array(.15, 1.5))
  irel3 = xoscb(32*4, array(.15, 3.5))


  hexplay("f000f004f000f00f",
    "Puck", 
    p3-(p3*3/4),
    in_scale(0, xoscb(32*2, array(0, -5, -4, 0, 1, -4))),
    ampdbfs(p4 % 16 == 0 ? -12 : random(-9, -12)),
    1,
    random(.05, irel1))

  hexplay("f000f000f000f00f",
    "Puck", 
    p3-(p3*3/4),
    in_scale(0, xoscb(32, array(2, -3, 0))),
    ampdbfs(p4 % 16 == 0 ? -12 : random(-9, -12)),
    1,
    random(.05, irel2))

  hexplay("f000f004f000fff",
    "Puck", 
    p3-(p3*3/4),
    in_scale(-1, xoscb(32, array(-2, 0, -2))),
    ampdbfs(p4 % 16 == 0 ? -12 : random(-9, -12)),
    1,
    random(.05, irel3))

endin

instr P1
endin
