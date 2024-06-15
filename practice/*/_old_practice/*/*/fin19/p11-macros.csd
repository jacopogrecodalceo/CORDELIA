set_tempo(165)

instr P1

  set_scale("whole")
  set_root("4D")


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
#define long	#random(iquarter * 5, iquarter * 7)#
#define med	#random(iquarter, iquarter * 3)#
#define short	#random(0, iquarter)#

;end

  hexplay("80100",
    "Puck", 
    p3,
    in_scale(0, 4 + xoscb(2, array(0, 2))),
    p4 % 5 == 0 ? $f : $mf,
    1,
    $long)

  hexplay("80500",
    "Puck", 
    p3,
    in_scale(0, 1 + xoscb(2, array(0, 1))),
    p4 % 5 == 0 ? $f : $mf,
    1,
    $long)

  hexplay("80400",
    "Puck", 
    p3,
    in_scale(-1, xoscb(3, array(0, -5, -4, 0, 1, -4))),
    p4 % 5 == 0 ? $f : $mf,
    1,
    $long)

endin
