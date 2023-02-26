set_tempo(65)

instr P1

  if (phsm(2) == 0) then
    go_tempo(95, 1)
  endif

  imes = 4

  if (phsm(imes) == 0) then
    Sroot = "3B"
    Sscale = "whole"
    set_scale(Sscale)
    set_root(Sroot)
  elseif (phsm(imes) == 1/imes) then
    Sroot = "4D"
    Sscale = "maj"
    set_scale(Sscale)
    set_root(Sroot)
  elseif (phsm(imes) == 2/imes) then
    Sroot = "3F#"
    Sscale = "min"
    set_scale(Sscale)
    set_root(Sroot)
  elseif (phsm(imes) == 3/imes) then
    Sroot = "3A"
    Sscale = "mixolydian"
    set_scale(Sscale)
    set_root(Sroot)
  endif

  hexplay("abd",
      "StJacques1", p3,
      in_scale(-1, (p4 % 8 == 0 ? 0 : (p4 % 7 * 3))),
      fade_out(1, 48) * ampdbfs(random(-12, -24)),
      1,
      random(.05, 1.5))

  if (phs(4) == .5) then
    hexplay("abdabe",
      "StJacques2", p3,
      in_scale(0, (p4 % 4 == 0 ? 0 : int(random(-15, 15)))),
      fade_out(2, 32) * ampdbfs(random(-7, -12)),
      2,
      random(7.5, 11.5))
  endif

  hexplay("a97b",
      "StJacques3", p3,
      in_scale(-2, (p4 % 3 * 2)),
      fade_out(3, 32) * ampdbfs(random(-7, -12)),
      3,
      random(1.25, 3.5))

  hexplay("8",
      "BD", p3,
      in_scale(0, 1),
      fade_out(11, 64) * ampdbfs(-9))

endin

instr P1
endin

instr StJacques1

  seed 0

  alfo = 1 + oscili(random(.0025, .015), random(.25, 3.5))

  asig =  oscili(p5, p4 * alfo, giTri)
  asig += oscili(p5, p4 * 3 * alfo, giSine)
  asig += oscili(p5/24, p4 * 9 * alfo, giTri)
  asig += oscili(p5/32, p4 * 11 * alfo, giTri)

  asig *= mxadsr:a(.0135, .025, .35, p7)


  apan = .5 + oscili(.5, random(.125, 1.5))

  a1, a2 pan2 asig, apan 

  out(a1, a2)

endin

instr StJacques2

  seed 0

  alfo = 1 + oscili(random(.0025, .015), random(.25, 3.5))

  asig =  oscili(p5, p4 * alfo, giTri)
  asig += oscili(p5, p4 * 3 * alfo, giSine)
  asig += oscili(p5/24, p4 * 9 * alfo, giTri)
  asig += oscili(p5/32, p4 * 11 * alfo, giTri)

  asig *= mxadsr:a(.0135, .025, .35, p7)


  apan = .5 + oscili(.5, random(.125, 1.5))

  a1, a2 pan2 asig, apan 

  out(a1, a2)

endin

instr StJacques3

  seed 0

  alfo = 1 + oscili(random(.0025, .015), random(.25, 3.5))

  asig =  oscili(p5, p4 * alfo, giTri)
  asig += oscili(p5, p4 * 3 * alfo, giSine)
  asig += oscili(p5/24, p4 * 9 * alfo, giTri)
  asig += oscili(p5/32, p4 * 11 * alfo, giTri)

  asig *= mxadsr:a(.0135, .025, .35, p7)


  apan = .5 + oscili(.5, random(.125, 1.5))

  a1, a2 pan2 asig, apan 

  out(a1, a2)

endin

