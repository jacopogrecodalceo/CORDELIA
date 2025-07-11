;	instr 900, mouth
;	instr 950, clearer
;	instr 955, checker

indx	init 0
until	indx == ginchnls do
	schedule  900+((indx+1)/1000), 0, -1, indx
	indx += 1
od

;garecorder[]	init ginchnls

gksoul_tape_drive = 2.5
gksoul_tape_wet = 1/9

;-----------------------------------------
	instr 900; MOUTH

ich	init p4
	prints("👅---%f\n", p1)

ain	chnget gSmouth[ich]

aout	= ain*gkgain

/* ihfreq			init ntof("3B")	; ~264Hz
khq				= 1.95+jitter:k(.405, gkbeatf/48, gkbeatf)

ilfreq			init ntof("2B")	; ~123Hz
klq				= 2.15+jitter:k(.305, gkbeatf/64, gkbeatf)

ahigh 			skf apre_out, ihfreq, khq, 1
alow 			skf apre_out, ilfreq, klq

apost_out		= ahigh+alow */

;alow	rezzy aout, ifreq_low, kq
;alow	diode_ladder aout, ifreq_low, kq , 1, $M_LOG2E

asat		tanh gksoul_tape_drive * aout
asat 		tone asat, 9500
aout		= (1 - gksoul_tape_wet) * aout + gksoul_tape_wet * asat

;aout dcblock aout
aout	butterhp aout, 20

	outch gioffch+ich+1, aout

;garecorder[ich] = aout

;	CLEAR
;	chnclear gSmouth[ich]

	endin

;turnoff2_i 900, 0, 0

/*	instr main_recorder

Swrite	init p4
		fout Swrite, -1, garecorder

		clear garecorder

	endin*/

	instr 945

Sinstrs[]	init ginchnls
arec[]		init ginchnls

Sinstr		strget	p4
Sname		strget	p5

indx		init 0
until	indx == ginchnls do
	Sinstrs[indx]	sprintf "%s_%i", Sinstr, indx+1
	indx += 1
od

arec	chngeta Sinstrs

		fout Sname, -1, arec

	endin

	instr 950
Sinstr	strget	p4
prints "%s is clear\n", Sinstr
	chnclear Sinstr
	endin


