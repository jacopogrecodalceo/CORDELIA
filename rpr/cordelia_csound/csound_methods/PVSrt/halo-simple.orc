sr = 96000

giSPEED		init 1

gifft_size  init pow(2, 12) ; 12 = 4096
gioverlap  init gifft_size / 4
giwinshape init 1							; von-Hann window
;girelease_time init 1
; ============
; *** OPCODE ***
; ============
opcode file_to_pvs_buf, ii, Siiiiii
Sfile, gifft_size, ioverlap, iwinsize, iwinshape, ilen_file, ifn xin
	ktimek		timeinstk
	if ktimek == 1 then
		ilen		filelen	Sfile
		kcycles	=		ilen * kr
		kcount		init		0
		loop:
			; ============
			; *** READ ***
			; ============
			atime		phasor 1/ilen_file
			ain			table3 atime, ifn, 1

			fftin		pvsanal	ain, gifft_size, ioverlap, iwinsize, iwinshape
			ibufln      =   ilen + (gifft_size / sr)    
			ibuf, ktim	pvsbuffer	fftin, ibufln

		loop_lt	kcount, 1, kcycles, loop
		xout		ibuf, ilen
	endif
endop

; ============
; *** TABs ***
; ============
ich     filenchnls gSfile
indx    init 0
until indx == ich do
	inum init indx + 1
	itab ftgen inum, 0, 0, 1, gSfile, 0, 0, inum
	indx += 1
od

	instr 1

; ============
; *** INIT ***
; ============
ich			init p4
ifn			init p4
ilen_file	init ftlen(ifn)/ftsr(ifn)


; ============
; *** VARs ***
; ============
ispeed 		init giSPEED ; [idur*ispeed]
kport		= 0
; ============
p3			init ilen_file*ispeed
idur		init p3
; ============

iwinsize  init gifft_size
;	xtratim girelease_time

ibuffer, ilen	file_to_pvs_buf gSfile, gifft_size, gioverlap, iwinsize, giwinshape, ilen_file, ifn


kread		linseg 0, p3, ilen
fread 		pvsbufread  kread, ibuffer;, ilo, ihi
aread		pvsynth	fread

aout		= aread

outch ich, aout

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