	instr 1

; ============
; *** INIT ***
; ============
Satsfile	init p4
ich			init p5

; ============
; *** INFO ***
; ============
inum_partials		init 25
gidur				ATSinfo Satsfile, 7

inum		init 25

indx		init 0
inum		limit inum, 1, inum_partials

until indx > inum do
	schedule	2, 0, 1, Satsfile, ich, indx
	indx	+= 1
od

	endin

	instr 2
; ============
; *** INIT ***
; ============
p3				init gidur
Satsfile		init p4
ich				init p5
ipartial		init p6
iamp			init 1
ifreq			init 1
is_first_used	init 0

; ============
; *** READ ***
; ============
kread 			line 0, p3, gidur
anoise			ATSaddnz kread, Satsfile, ipartial, is_first_used

; ============
; *** CORE ***
; ============
aout		= anoise/24

; ============
; *** aOUT ***
; ============
	outch ich, aout
	
	endin

;---SCORE---
/* 
for i in range(1):
	code = [
		'i1',
		0,			# p2: when
		1,			# p3: dur
		ats_file,	# p4
		ch			# p5
	]
	score.append(' '.join(map(str, code)))
*/