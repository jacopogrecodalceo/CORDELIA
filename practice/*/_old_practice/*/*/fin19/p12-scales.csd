set_tempo(115)

instr P1

  set_scale("locrian")
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
#define long	#random(iquarter * 5, iquarter * 7)#
#define med	#random(iquarter, iquarter * 3)#
#define short	#random(0, iquarter)#

;end
  
  hexplay("e398",
    "Puck", 
    p3/(1+p4%24),
    in_scale(-1, (p4%48>23 ? 0 : 1) + p4%24),
    $mf,
    1,
    p4%3 == 0 ? $long : $short)

  hexplay("0009",
    "StJacques", 
    p3,
    in_scale(-1, (p4%48>23 ? 0 : 1) + p4%24),
    p4%3 == 0 ? $mp : $pp,
    1,
    $med)

  hexplay("8",
    "Impure", 
    p3,
    in_scale(-1, (p4%48>23 ? 0 : -2)),
    $pp,
    1,
    $short)

endin
