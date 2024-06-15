instr Score

	go_tempo(125, 1)
	gamme("locrian")
	root("3B")

endin

start("Score")

instr each16th
	ivoy = turner("Puck", 5, .05)
  
  if(eu(3, 9) == 1) then
    schedule("Puck", 0, p3,
	in_scale(-1, (p4%18>13 ? 0 : 1) + p4%14),
	$mp + ($mf*ivoy/5),
	5.05 + ivoy)
  endif

  if(eu(9, 13) == 1) then
    schedule("Puck", 0, p3,
	in_scale(0, (p4%48>23 ? 0 : 1) + (p4%192 > 127 ? 1 : 0)),
	p4%192 > 127 ? $f : $mf,
	p4%192 > 127 ? $long : $qshort)

  endif

  if(eu(13, 17) == 1) then
    schedule("Puck", 0, p3,
	in_scale(0, xoscb(3, array(0, -5, -4, 0, 1, -4))),
	$mf, $qshort)
  endif

  if(eu(9, 13) == 1) then
    schedule("CHH", 0, p3,
	in_scale(0, 0), $ff)
  endif

  if(eu(5, 12) == 1) then
    schedule("BD", 0, p3, 1, $ff)
  chnset($qlong, "BD.decay")	
  endif

endin

reset_clock()
