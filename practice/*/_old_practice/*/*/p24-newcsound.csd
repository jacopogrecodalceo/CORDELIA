instr Score

	go_tempo(125, 1)
	gamme("locrian")
	root("3B")

endin

set_tempo(75)

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
imillisec	= .05

#define long	#random(imillisec * 5, imillisec * 7)#
#define med	#random(imillisec, imillisec * 3)#
#define short	#random(.005, imillisec)#

#define qlong	#random(iquarter * 5, iquarter * 7)#
#define qmed	#random(iquarter, iquarter * 3)#
#define qshort	#random(.005, iquarter)#
;end
	root("3B")
	gamme("locrian")
  
	if(eu(3, 11) == 1) then
		schedule("StJacques",
		0,
		p3,
		in_scale(0, xoscb(3, array(0, -5, -4, 0, 1, -4))),
		$f,
		$long)
	endif

endin
