;/Users/j/Documents/PROJECTs/CORDELIA/corlist/_corlist-score_scripted.csd

;---RECORD ON
schedule "MNEMOSINE", 0, -1, "__corlist.wav"

;-----1
$START	1,\
	"1.wav",\
	0,		\;DELAY STARTING SEQ
	0,		\;START SEQ FROM
	0,		\;IS LOOP
	1,		\;DYN
	0,	0,	\;FADEIN
	.005,	0	 ;FADEOUT
;---
$END	1, 0
;-----2
$START	2,\
	"2.wav",\
	0,		\;DELAY STARTING SEQ
	0,		\;START SEQ FROM
	0,		\;IS LOOP
	1,		\;DYN
	0,	0,	\;FADEIN
	.005,	0	 ;FADEOUT
;---
$END	2, 0
;-----3
$START	3,\
	"3.wav",\
	0,		\;DELAY STARTING SEQ
	0,		\;START SEQ FROM
	0,		\;IS LOOP
	1,		\;DYN
	0,	0,	\;FADEIN
	.005,	0	 ;FADEOUT
;---
$END	3, 0
;-----4
$START	4,\
	"4.wav",\
	0,		\;DELAY STARTING SEQ
	0,		\;START SEQ FROM
	0,		\;IS LOOP
	1,		\;DYN
	0,	0,	\;FADEIN
	.005,	0	 ;FADEOUT
;---
$END	4, 0

;---RECORD OFF & CLOSE
event_i "e", 0, 1

;---ENDLIST
;turnoff_i all instances (0), oldest only (1), or newest only (2), notes with exactly matching (fractional) instrument(4)
