instr Score

	go_tempo(125, 1)
	gamme("locrian")
	root("3B")

endin


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
imillisec	= .005

#define long	#random(imillisec * 5, imillisec * 7)#
#define med	#random(imillisec, imillisec * 3)#
#define short	#random(.005, imillisec)#

#define qlong	#random(iquarter * 5, iquarter * 7)#
#define qmed	#random(iquarter, iquarter * 3)#
#define qshort	#random(.005, iquarter)#
;end
	root("3B")
	gamme("locrian")
	go_tempo(115, 1)
  
  if(eu(xoscb(3, array(9, 4)), 11) == 1) then
    schedule("Puck",
	0,
	p3,
	in_scale(0, 1),
	$f,
	1,
	$short)
  endif

  if(eu(11, 12) == 1) then
    schedule("Puck",
	0,
	p3,
	in_scale(0, 2),
	$f,
	1,
	$short)
  endif

  if(eu(8, 12) == 1) then
    schedule("Puck",
	0,
	p3,
	in_scale(1, xoscb(3, array(3, 4))),
	$f,
	1,
	$short)
  endif

endin

  if(eu(2, 11) == 1) then
    schedule("Puck",
	0,
	p3,
	in_scale(-2, 2),
	$f,
	1,
	$short)
  endif

  if(eu(3, 13) == 1) then
    schedule("Puck",
	0,
	p3,
	in_scale(-2, 1),
	$mf,
	1,
	$short)
  endif
