;	instr 900, mouth
;	instr 950, clearer
;	instr 955, checker

indx	init 0
until	indx == ginchnls do
	schedule  900+((indx+1)/1000), 0, -1, indx
	indx += 1
od

;garecorder[]	init ginchnls

;-----------------------------------------
	instr 900; MOUTH

ich	init p4
	prints("👅---%f\n", p1)

ain	chnget gSmouth[ich]

ain	*= gkgain

aout	dcblock2 ain

ifreq_low init ntof("2B");~123Hz
kq	= .35+lfo:k(.105, gkbeatf/64)

alow	rezzy aout, ifreq_low, kq

;alow	diode_ladder aout, ifreq_low, kq , 1, $M_LOG2E

	outch gioffch+ich+1, aout+(alow*4)

;garecorder[ich] = aout

;	CLEAR
	chnclear gSmouth[ich]

	endin

turnoff2_i 900, 0, 0

	instr 950
Sinstr	strget	p4
prints "%s is clear\n", Sinstr
		chnclear Sinstr
	endin

/*
	instr 985

Swrite	init p4
		fout Swrite, -1, garecorder

		clear garecorder

	endin
*/


