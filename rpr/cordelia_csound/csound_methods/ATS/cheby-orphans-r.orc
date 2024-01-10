	instr 1

Satsfile		init p4
ich				init p5
imax_p			ATSinfo Satsfile, 3
gidur			ATSinfo Satsfile, 7

inum			init 31

indx			init 1
inum			limit inum, 1, imax_p
until indx > inum do
	schedule 2, 0, 1, Satsfile, ich, imax_p
	indx += 1
od
	endin

	instr 2
; ============
; *** INIT ***
; ============
p3				init gidur
Satsfile		init p4
ich				init p5
ipartial		int random(1, p6+1)
iamp			init 1
ifreq			init 1

; ============
; *** READ ***
; ============
kread 			line 0, p3, gidur
kfreq, kamp ATSread kread, Satsfile, ipartial

; ============
; *** CORE ***
; ============
ain 		oscili iamp*a(kamp), a(kfreq)*ifreq
ibeatf		init 1/4
#define jit #jitter(1, ibeatf/8, ibeatf)#

aout		chebyshevpoly  ain, 0, $jit, $jit, $jit, $jit, $jit, $jit, $jit
aout		balance2 aout, ain
aout		dcblock2 aout

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