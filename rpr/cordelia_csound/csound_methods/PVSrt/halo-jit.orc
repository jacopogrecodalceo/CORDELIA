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

gkjit 		init 0
gkport		init 1/2

	instr jitter

kmetro		metro randomh:k(1/8, 1, 1/6)

kjit		init 0
kjit		samphold random:k(0, 1), kmetro

if changed2:k(kjit) == 1 then
	gkport random 1/2, filelen(gSfile)
endif

gkjit portk kjit, gkport
	endin
	alwayson("jitter")

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

kread_jit	= gkjit*ilen
fread_jit	pvsbufread  kread_jit, ibuffer
;fread_blur	pvsblur fread_jit, gkport, ilen_file
aread_jit	pvsynth	fread_jit

aout		= aread_jit; + reverb(aread_jit, 1+kjit*.05) 

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