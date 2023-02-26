set_tempo(35)

go_tempo(125, 1)

	gamme("locrian")

	root("3B")

instr each16th




;macro
#define fff	#ampdbfs(-4	+ random(-3, 3))#
#define ff	#ampdbfs(-10	+ random(-3, 3))#
#define f	#ampdbfs(-16	+ random(-3, 3))#
#define mf	#ampdbfs(-22	+ random(-3, 3))#
#define mp	#ampdbfs(-28	+ random(-3, 3))#
#define p	#ampdbfs(-34	+ random(-3, 3))#
#define pp	#ampdbfs(-40	+ random(-3, 3))#
#define ppp	#ampdbfs(-46	+ random(-3, 3))#

iquarter	= beats(1)
imillisec	= .015

#define long	#random(imillisec * 5, imillisec * 7)#
#define med	#random(imillisec, imillisec * 3)#
#define short	#random(.005, imillisec)#

#define qlong	#random(iquarter * 5, iquarter * 7)#
#define qmed	#random(iquarter, iquarter * 3)#
#define qshort	#random(.005, iquarter)#
;end
	ivoy = turner("Puck", 5, .05)
  
  if(eu(3, 9) == 1) then
    schedule("Puck", 0, p3,
	in_scale(-1, (p4%18>13 ? 0 : 1) + p4%14),
	$mf + ($f*ivoy/5),
	1,
	5.05 + ivoy)
  endif

  if(eu(9, 13) == 1) then
    schedule("Puck", 0, p3,
	in_scale(0, (p4%48>23 ? 0 : 1) + (p4%192 > 127 ? 1 : 0)),
	p4%192 > 127 ? $ff : $f,
	1,
	p4%192 > 127 ? $qlong : $qshort)

  endif

  if(eu(13, 17) == 1) then
    schedule("Puck", 0, p3,
	in_scale(0, xoscb(3, array(0, -5, -4, 0, 1, -4))),
	$f, 1, $qshort)
  endif

  if(eu(9, 13) == 1) then
    schedule("CHH", 0, p3,
	in_scale(0, 0), 1)
  endif

  if(eu(5, 12) == 1) then
    schedule("BD", 0, p3, 1, $ff)
  chnset($qlong, "BD.decay")	
  endif

endin

reset_clock()
