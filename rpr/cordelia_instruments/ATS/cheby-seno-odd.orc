	instr 1

; ============
; *** INIT ***
; ============
Satsfile	init p4
ich			init p5

; ============
; *** INFO ***
; ============
imax_p		ATSinfo	Satsfile, 3
gidur		ATSinfo	Satsfile, 7

inum		init imax_p

indx		init 1
inum		limit inum, 1, imax_p

until indx > inum do
	if indx % 2 == 1 then
		schedule 2, 0, 1, Satsfile, ich, indx
	endif
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
kfreq, kamp ATSread kread, Satsfile, ipartial

; ============
; *** CORE ***
; ============
ibeatf		init 1/4
#define jit #jitter(1, ibeatf/8, ibeatf)#

kbase_freq	= kfreq*ifreq
kcent_var	abs kbase_freq-(kbase_freq*cent(50))

afreq		= kbase_freq+(kcent_var*$jit)
ain 		oscili iamp*a(kamp), afreq
aout		= ain

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