giCUT_OFF		init 75 	; initial cutoff frequency used to define the vocoder bands
giUPPER_BOUND	init 7500 	; upper bound of the frequency range to which the vocoder bands will be applied
giQ				init 7 		; Q factor or resonance for each vocoder band filter
giST_SIZE		init 5 		; interval size in semitones by which the band frequencies are spaced. In this case, a value of 4 means that the band frequencies are spaced at a distance of 4 semitones

; ============
; *** DEFAULTs ***
; ============
gaEX[]			init nchnls
giLEN_FILE 	init 0
giCHNS_FILE	init 0
schedule 4, 0, -1

	instr 1

Satsfile		init p4
ich				init p5
imax_p			ATSinfo Satsfile, 3
giLEN_FILE		ATSinfo Satsfile, 7
giCHNS_FILE 	init p6

inum			init imax_p

indx			init 1
inum			limit inum, 1, imax_p
until indx > inum do
	schedule 2, 0, giLEN_FILE, Satsfile, ich, indx
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
ifreq			init 1
inum			init (ich-1)%giCHNS_FILE
kdyn_smooth		init 1/24
; ============
; *** READ ***
; ============
kread 			line 0, p3, p3
kcps, kdyn		ATSread kread, Satsfile, ipartial

; ============
; *** CORE ***
; ============
if kdyn > ampdbfs(-15) then
	kdyn_smooth = kdyn
else
	kdyn_smooth portk kdyn, 1
endif

ain = vco2(kdyn_smooth, kcps*0.99*ifreq) + vco2(kdyn_smooth, kcps*1.01*ifreq)
#define jit #random:i(-1, 1)#

aout		chebyshevpoly  ain, 0, $jit, $jit, $jit, $jit, $jit, $jit, $jit
aout		balance2 aout, ain
aout		dcblock2 aout

gaEX[inum]		init 0

; ============
; *** aOUT ***
; ============
gaEX[inum]	= gaEX[inum] + aout

	schedule 3+ich/1000, 0, p3, giCUT_OFF, ich

	endin

	instr 3  // recursive vocoder bands
ich		init p5
inum	init (ich-1)%giCHNS_FILE

aout 	= butterbp(butterbp(gaEX[inum], p4, p4/giQ), p4, p4/giQ) * rms(butterbp(butterbp(gaEX[inum], p4, p4/giQ), p4, p4/giQ))
;adel flanger aout, a(1/giFREQ), .5+jitter:k(.5, giFREQ, 1/giFREQ)
inxt 	= p4*2^(giST_SIZE/12)
if inxt < giUPPER_BOUND then
	inum_instr init p1+(1/(1000*1000))
	;printf_i "%.09f\n", 1, p1
	;printf_i "%.09f\n", 1, inum_instr
	schedule inum_instr, 0, -1, inxt, ich
endif

	outch ich, aout*8

	endin

	instr 4
	clear gaEX
	endin


;---SCORE---
/* 
for i in range(1):
	code = [
		'i1',
		0,			# p2: when
		1,			# p3: dur
		ats_file,	# p4
		ch,			# p5
		len(ats_files) # p6
	]
	score.append(' '.join(map(str, code)))
*/