; ============
; *** TABs ***
; ============
giCHNS_FILE filenchnls gSfile
ich init 1
until ich > giCHNS_FILE do
	itab ftgen ich, 0, 0, 1, gSfile, 0, 0, ich
	ich += 1
od

; changement frequency of pitch detection
giFREQ			init 8

giCUT_OFF		init 75 	; initial cutoff frequency used to define the vocoder bands
giUPPER_BOUND	init 7500 	; upper bound of the frequency range to which the vocoder bands will be applied
giQ				init 7 		; Q factor or resonance for each vocoder band filter
giST_SIZE		init 5 		; interval size in semitones by which the band frequencies are spaced. In this case, a value of 4 means that the band frequencies are spaced at a distance of 4 semitones

giTHRESH		init ampdbfs(-15) ; threshold for pitch detection

; ============
; *** DEFAULTs ***
; ============
gaOUT[]			init nchnls
gaEX[]			init nchnls
giLEN_FILE		filelen gSfile

schedule 4, 0, -1

giFFT_SIZE  init pow(2, 12) ; 12 = 4096
giOVERLAP  init giFFT_SIZE / 4
giWIN init 1							; von-Hann window
;girelease_time init 1
; ============
; *** OPCODE ***
; ============
opcode file_to_pvs_buf, ii, Siiiiii

Sfile, giFFT_SIZE, ioverlap, iwinsize, iwinshape, giLEN_FILE, ifn xin
	ktimek		timeinstk
	if ktimek == 1 then
		ilen		filelen	Sfile
		kcycles	=		ilen * kr
		kcount		init		0
		loop:
			; ============
			; *** READ ***
			; ============
			atime		phasor 1/giLEN_FILE
			ain			table3 atime, ifn, 1

			fftin		pvsanal	ain, giFFT_SIZE, ioverlap, iwinsize, iwinshape
			ibufln      =   ilen + (giFFT_SIZE / sr)    
			ibuf, ktim	pvsbuffer	fftin, ibufln

		loop_lt	kcount, 1, kcycles, loop
		xout		ibuf, ilen
	endif
endop

; ============
; *** JITTER ***
; ============
gkJITTER 		init 0
gkport		init 1/2

	instr jitter

kmetro		metro randomh:k(1/8, 1, 1/6)

kjit		init 0
kjit		samphold random:k(0, 1), kmetro

if changed2:k(kjit) == 1 then
	gkport random 1/2, filelen(gSfile)
endif

gkJITTER portk kjit, gkport
	endin
	alwayson("jitter")


; ============
; *** INSTR ***
; ============
	instr 1

; ============
; *** INIT ***
; ============
ich				init p4
inum			init ich-1
ifn				init (inum%giCHNS_FILE)+1

gaOUT[inum]		init 0

; ============
; *** VARs ***
; ============
ispeed 		init 1 ; [idur*ispeed]

; ============
p3			init giLEN_FILE*ispeed
idur		init p3
; ============

; ============
; *** READ ***
; ============
atime		phasor 1/idur
aout		table3 atime, ifn, 1

gaOUT[inum] = gaOUT[inum] + aout

	schedule 2+ich/1000, 0, p3, ich
	schedule 3+ich/1000, 0, p3, giCUT_OFF, ich

	endin

	instr 2 // synth

kfreq			init ntof("4B")

ich				init p4
inum			init ich-1
ifn				init (inum%giCHNS_FILE)+1

gaEX[inum]		init 0

iwin_size  		init giFFT_SIZE
ibuffer, ilen	file_to_pvs_buf gSfile, giFFT_SIZE, giOVERLAP, iwin_size, giWIN, giLEN_FILE, ifn

kread_jit		= gkJITTER*ilen
fread_jit		pvsbufread  kread_jit, ibuffer
kfreq, kamp 	pvspitch fread_jit, giTHRESH

if kfreq != 0 then
	kcps = kfreq
endif

;kcps 		*= int(randomh(1, 5, giFREQ))
aex			= vco2(1, kcps*0.99) + vco2(1, kcps*1.01)
gaEX[inum]	= gaEX[inum] + aex
	endin

	instr 3  // recursive vocoder bands
ich		init p5
inum	init (ich-1)%giCHNS_FILE

aout 	= butterbp(butterbp(gaEX[inum], p4, p4/giQ), p4, p4/giQ) * rms(butterbp(butterbp(gaOUT[inum], p4, p4/giQ), p4, p4/giQ))
;adel flanger aout, a(1/giFREQ), .5+jitter:k(.5, giFREQ, 1/giFREQ)
inxt 	= p4*2^(giST_SIZE/12)
if inxt < giUPPER_BOUND then
	inum_instr init p1+(1/(1000*1000))
	;printf_i "%.09f\n", 1, p1
	;printf_i "%.09f\n", 1, inum_instr
	schedule inum_instr, 0, -1, inxt, ich
endif

	outch ich, aout

	endin

	instr 4
	clear gaOUT
	clear gaEX
	endin

;---SCORE---
/* 
for i in range(1):
	code = [
		'i1',
		0,			# p2: when
		1,			# p3: dur
		ch			# p4
	]
	score.append(' '.join(map(str, code)))
*/

; ============
; from Victor Lazzarini mailing list Vocoder in Csound 7
; after the ICSC24
; 10/2024
; ============