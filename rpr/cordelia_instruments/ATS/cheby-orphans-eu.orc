opcode	euarm_sched, 0, iiiSiii
	inum_str, istart, idur, Satsfile, ich, ionset, ipulse xin

ilen	init ipulse
iprev	init -1
ieu[]	init ilen
indx	init 0

irot	init 0

while indx < ipulse do
	ival			=	int((ionset / ipulse) * indx)
	indxrot			=	(indx + irot) % ipulse
	ieu[indxrot]	=	(ival == iprev ? 0 : 1)
	iprev			=	ival
	indx			+=	1
od

indx	init 0
while indx < ilen do
	if ieu[indx] == 1 then
		schedule inum_str, istart, idur, Satsfile, ich, indx+1
	endif		
	indx += 1
od

	endop

gisaw	ftgen 0, 0, 8192, 7, 1, 8192, -1

	instr 1

Satsfile		init p4
ich				init p5
imax_p			ATSinfo Satsfile, 3
gidur			ATSinfo Satsfile, 7

ionset			init 15

indx			init 1
ionset			limit ionset, 1, imax_p

	euarm_sched 2, 0, 1, Satsfile, ich, ionset, imax_p
	turnoff
	endin

	instr 2
; ============
; *** INIT ***
; ============ 
idur			init gidur
p3				init idur
Satsfile		init p4
ich				init p5
ipartial		init p6
iamp			init 1
ifreq			init 1

; ============
; *** READ ***
; ============
kread 			line 0, p3, idur
kfreq, kdyn		ATSread kread, Satsfile, ipartial
adyn			a kdyn
afreq			a kfreq

; ============
; *** CORE ***
; ============
ain 		oscili iamp*adyn, ifreq*afreq
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
