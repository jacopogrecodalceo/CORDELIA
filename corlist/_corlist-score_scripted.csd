;		when	file				start	loop	gain	fadin	mode	fadout	mode

;---RECORD ON
schedule "MNEMOSINE", 0, -1, "__corlist.wav"

;---
schedule 1.001, 0, 1,\
	"armagain.wav",	\;filename
	0,	\;start from
	0,	\;is a loop (0 or 1)
	.5,	\;volume
	5,	\;fadein duration
	0,	\;fadein mode
	5,	\;fadeout duration
	0	;fadeout mode
;---
turnoff2_i 1.001, 4, 1
;---
schedule 1.002, 0, 1,\
	"contempo.wav",	\;filename
	0,	\;start from
	0,	\;is a loop (0 or 1)
	.5,	\;volume
	5,	\;fadein duration
	0,	\;fadein mode
	5,	\;fadeout duration
	0	;fadeout mode
;---
turnoff2_i 1.002, 4, 1
;---
schedule 1.003, 0, 1,\
	"crij.wav",	\;filename
	0,	\;start from
	0,	\;is a loop (0 or 1)
	.5,	\;volume
	5,	\;fadein duration
	0,	\;fadein mode
	5,	\;fadeout duration
	0	;fadeout mode
;---
turnoff2_i 1.003, 4, 1
;---
schedule 1.004, 0, 1,\
	"cril.wav",	\;filename
	0,	\;start from
	0,	\;is a loop (0 or 1)
	.5,	\;volume
	5,	\;fadein duration
	0,	\;fadein mode
	5,	\;fadeout duration
	0	;fadeout mode
;---
turnoff2_i 1.004, 4, 1

;---RECORD OFF & CLOSE
event_i "e", 0, 1

;---ENDLIST
;turnoff_i all instances (0), oldest only (1), or newest only (2), notes with exactly matching (fractional) instrument(4)
