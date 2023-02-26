set_tempo(35)

go_tempo(125, 1)

instr P1
  if (phsm(8) < .5) then
	set_scale("locrian")
  endif

  set_root("3B")

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
  
  if(eu(3, 9) == 1) then
	ivoy = turner(5, .05)
    schedule("Puck", 0, p3,
	in_scale(-1, (p4%18>13 ? 0 : 1) + p4%14),
	$mf + ($mf*ivoy/5),
	1,
	5.05 + ivoy)
  endif
endin

reset_clock()
