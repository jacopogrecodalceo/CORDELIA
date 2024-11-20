gihanning 	ftgen 0, 0, 8192, 20, 2

giSPEED				init 1 		; [idur*ispeed]
giGRAIN_dur			init 1000	; in ms
giGRAIN_jit 		init giGRAIN_dur / 1.5
giGRAIN_window		init gihanning

; ============================================
; INSTR 0 INIT
; ============================================
gadur 		init 0
gastart		init 0

; ============================================
; INSTR 1
; ============================================
	instr 1
ivoices_count	init p4
; ============================================
p3				init giFILE_dur*giSPEED
idur			init p3
; ============================================
gadur			= giGRAIN_dur + a(jitter:k(giGRAIN_jit, 1/idur, 3/idur))
gadur			/= 1000
; ============================================
gastart			phasor 1/idur / 64
	endin

; ============================================
; INSTR 2
; ============================================
	instr 2
ich			init p4
ift			init p4
; ============================================
ivoice_num 			init p5
ivoices_count		init p6
iphase				divz ivoice_num, ivoices_count, 0
; ============
; *** VARs ***
; ============
ijitter_samps	init 1024
; ============
p3				init giFILE_dur*giSPEED
idur			init p3
; ============

; ============
; *** READ ***
; ============
aphasor			phasor 1/gadur, iphase

aenv_ph			pow aphasor, 1+abs(lfo(35, 1/k(gadur)/16))
aenv			table aenv_ph, giGRAIN_window, 1

asum1			= aphasor * samphold:a(gadur, aphasor)
asum2			samphold gastart*(giFILE_samp / sr), aphasor
andx			= (asum1+asum2) * sr

aout			table (andx + a(jitter:k(ijitter_samps, 3.5, 5))) % giFILE_samp, ift
aout			*= aenv

aout			/= ivoices_count

	outch ich, aout

	endin

;---SCORE---
/*
voices = 96
instr_1 = f'i 1 0 -1 {voices}'
if instr_1 not in score:
	score.append(instr_1)
for i in range(voices):
	code = [
		'i',
		round((2+ch/100+i/10000), 5),
		0,				# p2: when
		1,				# p3: dur
		ch,				# p4
		i,				# p5
		voices			# p6
	]
	score.append(' '.join(map(str, code)))
*/