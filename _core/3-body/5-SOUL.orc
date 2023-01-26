;	instr 900, mouth
;	instr 950, clearer
;	instr 955, checker

indx	init 0
until	indx == ginchnls do
	schedule  900+((indx+1)/1000), 0, -1, indx
	indx += 1
od
;-----------------------------------------
	instr 900; MOUTH

ich	init p4
	prints("👅---%f\n", p1)

aout	chnget gSmouth[ich]
aout	*= gkgain

	outch gioffch+ich+1, aout

;	CLEAR
	chnclear gSmouth[ich]

	endin


	instr 950
Sinstr	strget	p4
prints "%s is clear\n", Sinstr
		chnclear Sinstr
	endin


