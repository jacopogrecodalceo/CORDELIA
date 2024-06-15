set_tempo(95)

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

endin

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
      "StJacques", p3,
      in_scale(-1, (p4 % 8 == 0 ? 0 : (p4 % 7 * 3))),
      fade_in(1, 64) * ampdbfs(-12),
      random(.05, 1.5))

  if (phs(4) == .5) then
    hexplay("abdabe",
      "StJacques", p3,
      in_scale(0, (p4 % 4 == 0 ? 0 : int(random(-15, 15)))),
      fade_in(2, 32) * ampdbfs(-12),
      random(2.5, 3.5))
  endif

  hexplay("a97b",
      "StJacques", p3,
      in_scale(-2, (p4 % 3 * 2)),
      fade_in(3, 128) * ampdbfs(-12),
      random(.25, .5))

  hexplay("ffffff4",
      "BD", p3,
      in_scale(0, 1),
      fade_out(11, 64) * ampdbfs(-6))

  hexplay("8",
      "BD", p3,
      in_scale(0, 1),
      fade_out(15, 64) * ampdbfs(-6))

endin

instr P1
endin
