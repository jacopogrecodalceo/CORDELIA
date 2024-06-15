set_tempo(35)

go_tempo(135, 1)

instr P1

  if (phsm(8) < .5) then
	set_scale("ionian")
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
#define long	#random(iquarter * 5, iquarter * 7)#
#define med	#random(iquarter, iquarter * 3)#
#define short	#random(0, iquarter)#

;end
  
  igain = $mf

  hexplay("8a3c",
    "Disk", 
    p3,
    in_scale(0, 0),
    igain,
    1,
    $short,
    "adoration-00")

endin
