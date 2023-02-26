<CsoundSynthesizer>

<CsOptions>

</CsOptions>


<CsInstruments>

gkOct[] 	init	4 
gkDeg[] 	init	4 

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
	
	kindx = 0
	until kindx == 4 do
	printf "gk: %f %f\n", kindx + 1, gkOct[kindx], gkDeg[kindx]
kindx += 1
od


</CsInstruments>


<CsScore>
</CsScore>


</CsoundSynthesizer>