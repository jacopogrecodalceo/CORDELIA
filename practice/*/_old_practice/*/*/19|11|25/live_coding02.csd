<CsoundSynthesizer>

<CsOptions>

</CsOptions>


<CsInstruments>

ikOct[] 	init	4 
ikDeg[] 	init	4 

indx 	=	0 
until	indx == 4 do 
inum 	=	rand(1) 
ikOct[indx] 	=	inum 
printf	"ikOct[%d] = %f\n", indx + 1, indx, inum 
indx += 1
od

indx 	=	0 
until	indx == 4 do 
inum 	random	0, 12 
ikDeg[indx] 	=	inum 
printf	"ikDeg[%d] = %f\n", indx + 1, indx, inum 
indx += 1
od

indx 	=	0 
until	indx == 4 do 
printf	"gk: %f %f\n", indx + 1, ikOct[indx], ikDeg[indx] 
indx += 1
od

instr Sine
	alfo = 1 + oscili(random(.0025, .015), random(.25, 3.5))
  
	asig = oscili(1, p4 * alfo)
asig	+=	oscili(1, p4 * 3 * alfo)
asig	*=	expon(p5, p3, .00025)
  
out(asig, asig)
endin

instr Chord
	indx = 0
	until indx == 4 do
schedule("Sine", 0, 5, in_scale(ikOct[indx], giDeg[indx]), ampdbfs(-24))
od
endin

  
instr Go
schedule("Chord", 0, 0)
  
if(p4 <= 2) then
schedule(p1, 1, 3, p4 + 1)
endif
endin

schedule("Go", 0, 0)

schedule("Sine", 0, 5, in_scale(.25, 2), ampdbfs(-24))

</CsInstruments>


<CsScore>
#include	livecode.orc

i	"Go"	0	5
</CsScore>


</CsoundSynthesizer>