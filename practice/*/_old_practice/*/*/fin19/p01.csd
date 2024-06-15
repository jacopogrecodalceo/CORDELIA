gideg init 0

instr StJacques

  seed 0

  alfo = 1 + oscili(random(.0025, .015), random(.25, 3.5))

  asig =  oscili(p5, p4 * alfo, giTri)
  asig += oscili(p5, p4 * 3 * alfo, giSine)
  asig += oscili(p5/24, p4 * 9 * alfo, giTri)
  asig += oscili(p5/32, p4 * 11 * alfo, giTri)

  asig *= mxadsr:a(.0135, .025, .35, p6)

  apan = .5 + oscili(.5, random(.125, 1.5))

  a1, a2 pan2 asig, apan 

  out(a1, a2)
  
  if (gideg < lenarray(gi_cur_scale) - 1) then
  gideg += 1
  else gideg init 0
  endif

  inote ftom p4  
  Sdeg mton inote

  prints("note is %s\ndegree is %d\nf = %d\n\n", Sdeg, gideg, p4)

endin

instr P1

  set_tempo(125)

  if (phsm(2) == 0) then
  set_root("4G")
  set_scale("whole")
  elseif (phsm(2) == .5) then
  set_root("4C")
  set_scale("loc")
  endif

  hexplay("1d8dfa",
      "StJacques", p3,
      in_scale(0, gideg+1),
      ampdbfs(-12),
      random(.5, 1.5))

endin

instr P1
endin
