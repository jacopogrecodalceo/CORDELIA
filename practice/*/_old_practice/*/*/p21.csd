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
imillisec	= .015

#define long	#random(imillisec * 5, imillisec * 7)#
#define med	#random(imillisec, imillisec * 3)#
#define short	#random(.005, imillisec)#

#define qlong	#random(iquarter * 5, iquarter * 7)#
#define qmed	#random(iquarter, iquarter * 3)#
#define qshort	#random(.005, iquarter)#
;end
  
  if(eu(11, 11) == 1) then
    schedule("Puck",
	0,
	p3*2,
	in_scale(0, 1),
	$mf,
	1,
	$qshort)
  endif

  if(eu(12, 12) == 1) then
    schedule("Puck",
	0,
	p3*2,
	in_scale(0, 2),
	$mf,
	1,
	$qshort)
  endif

  if(eu(1, 11) == 1) then
    schedule("Puck",
	0,
	p3*6,
	in_scale(-2, 2),
	$mp,
	1,
	$qshort)
  endif


endin
