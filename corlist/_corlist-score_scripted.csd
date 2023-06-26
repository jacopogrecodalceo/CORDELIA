;/Users/j/Documents/PROJECTs/CORDELIA/corlist/_corlist-score_scripted.csd

;---RECORD ON
schedule "MNEMOSINE", 0, -1, "__corlist.wav"

;---
schedule 1.001, 0, 1,\
	"1.wav",\
	0,		\;START FROM
	0,		\;IS LOOP
	1,		\;DYN
	0,	0,	\;FADEIN
	0,	0	 ;FADEOUT
;---
turnoff2_i 1.001, 4, 1
;---
schedule 1.002, 0, 1,\
	"2.wav",\
	0,		\;START FROM
	0,		\;IS LOOP
	1,		\;DYN
	0,	0,	\;FADEIN
	0,	0	 ;FADEOUT
;---
turnoff2_i 1.002, 4, 1
;---
schedule 1.003, 0, 1,\
	"3.wav",\
	0,		\;START FROM
	0,		\;IS LOOP
	1,		\;DYN
	0,	0,	\;FADEIN
	0,	0	 ;FADEOUT
;---
turnoff2_i 1.003, 4, 1
;---
schedule 1.004, 0, 1,\
	"4.wav",\
	0,		\;START FROM
	0,		\;IS LOOP
	1,		\;DYN
	0,	0,	\;FADEIN
	0,	0	 ;FADEOUT
;---
turnoff2_i 1.004, 4, 1

;---RECORD OFF & CLOSE
event_i "e", 0, 1

;---ENDLIST
;turnoff_i all instances (0), oldest only (1), or newest only (2), notes with exactly matching (fractional) instrument(4)
