set_tempo(35)

go_tempo(155, 1)

instr P1
  if (phsm(8) < .5) then
	set_scale("whole")
  else
	set_scale("pmaj")
  endif

  set_root("4B")

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
#define short	#random(0, imillisec)#

#define qlong	#random(iquarter * 5, iquarter * 7)#
#define qmed	#random(iquarter, iquarter * 3)#
#define qshort	#random(0, iquarter)#

;end
  
  igain = fade_in(1, 32) * $mf

  hexplay("8a3c",
    "Puck", 
    p3,
    in_scale(0, xoscb(16, array(1, 3, 2, -1)) + (p4%7==0?0:-1)),
    igain,
    2,
    $short)

  hexplay("77ab",
    "Puck", 
    p3,
    in_scale(0, xoscb(16, array(1, 3, 2, -1)) + (p4%7==0?0:1)-5),
    igain,
    2,
    $short)

  hexplay("374a5b3",
    "Puck", 
    p3,
    in_scale(0, xoscb(12, array(3, 2, -1)) + (p4%3==0?0:-6)-3),
    igain,
    2,
    $short)

endin



  hexplay("800000",
    "Impure", 
    p3,
    in_scale(1, xoscb(5, array(0, 1, -3, -2))),
    $p,
    1,
    $long)

  hexplay("000000020",
    "StJacques", 
    p3,
    in_scale(-4, xoscb(4, array(1, 1, 1, -5))),
    $mf,
    3,
    $long)

  hexplay("a00000000",
    "StJacques", 
    p3,
    in_scale(-4, xoscb(4, array(1, 1, 1, -5))),
    $fff,
    3,
    $med)
