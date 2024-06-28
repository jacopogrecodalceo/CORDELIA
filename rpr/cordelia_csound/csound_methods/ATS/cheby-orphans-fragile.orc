	instr 1

Satsfile		init p4
ich				init p5
imax_p			ATSinfo Satsfile, 3
gidur			ATSinfo Satsfile, 7

inum			init imax_p

indx			init 1
inum			limit inum, 1, imax_p
until indx > inum do
	schedule 2, 0, 1, Satsfile, ich, indx
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
ipartial		init p6
iamp			init 1
ifreq			init 1

; ============
; *** READ ***
; ============
kread 			line 0, p3, gidur
kfreq, kamp		ATSread kread, Satsfile, ipartial

; ============
; *** CORE ***
; ============
ain 		oscili iamp*a(kamp), a(kfreq * 1+abs(jitter:k(4, 13/p3, 20/p3))*abs(jitter:k(4, 13/p3, 20/p3)))
ibeatf		init 1/4
#define jit #random:i(-1, 1)#

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