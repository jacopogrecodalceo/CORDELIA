	instr 1

Satsfile		init p4
ich				init p5

imax_parts		ATSinfo Satsfile, 3
gidur_file		ATSinfo Satsfile, 7

inum			init imax_parts

indx			init 1
inum			limit inum, 1, imax_parts
until indx > inum do
	schedule 2, 0, 1, Satsfile, ich, indx
	indx += 1
od
	endin

	instr 2
; ============
; *** INIT ***
; ============
Satsfile		init p4
ich				init p5
ipartial		init p6

; ============
; *** MODs ***
; ============
ifact_dyn		init 1
ifact_freq		init 1

iread_rate		init gidur_file
iread_start		init 0
iread_end		init gidur_file

idur			init iread_rate
p3				init iread_rate

; ============
; *** READ ***
; ============
kread 					line iread_start, iread_rate, iread_end
kATS_freq, kATS_dyn		ATSread kread, Satsfile, ipartial

kATS_freq	*= ifact_freq
kATS_dyn	*= ifact_dyn

; ============
; *** CORE ***
; ============
aout		oscili kATS_dyn, kATS_freq

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