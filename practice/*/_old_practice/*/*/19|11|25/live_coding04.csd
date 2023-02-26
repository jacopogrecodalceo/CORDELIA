<CsoundSynthesizer>

<CsOptions>

</CsOptions>


<CsInstruments>

gkOct[] 	init	4 
gkDeg[] 	init	4 

instr OctaveDeg
	kindx init 0

	until kindx == 4 do
	knum = rand(1)
	gkOct[kindx] = knum
	printf "gkOct[%d] = %f\n", kindx + 1, kindx, knum
kindx += 1
od

	kindx = 0
	until kindx == 4 do
	knum random 0, 12
	gkDeg[kindx] = knum
	printf "gkDeg[%d] = %f\n", kindx + 1, kindx, knum
kindx += 1
od
	turnoff

endin

instr Sine
	alfo = 1 + oscili(random(.0025, .015), random(.25, 3.5))
  
	asig = oscili(1, p4 * alfo)
asig	+=	oscili(1, p4 * 3 * alfo)
asig	*=	expon(p5, p3, .00025)
  
out(asig, asig)
endin

instr Chord
	kindx = 0
	until kindx == 4 do
	k1 = gkOct[kindx]
	k2 = gkDeg[kindx]
	printk2 k1
	printk2 k2
	kscale = in_scale(k1, k2)
	event("i", "Sine", 0, 5, kscale, ampdbfs(-12))
kindx += 1
od
	turnoff
endin

</CsInstruments>


<CsScore>
#include livecode.orc

i	"OctaveDeg"	0	.05
i	"Chord"	0	.05
</CsScore>


</CsoundSynthesizer>