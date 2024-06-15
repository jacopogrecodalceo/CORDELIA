set_tempo(35)

go_tempo(155, 1)

instr P1
  if (phsm(8) < .5) then
	set_scale("whole")
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
  
  if(euclid(3, 21) == 1) then
    schedule("StJacques", 0, p3, in_scale(0, 1), $mf, 1, $short)
  endif

  if(euclid(5, 21) == 1) then
    schedule("StJacques", 0, p3, in_scale(0, 2), $mf, 1, $short)
  endif

  if(euclid(7, 21) == 1) then
    schedule("StJacques", 0, p3, in_scale(0, 3), $mf, 1, $med)
  endif

  if(euclid(9, 21) == 1) then
    schedule("StJacques", 0, p3, in_scale(0, 4), $p, 1, $short)
  endif

endin
