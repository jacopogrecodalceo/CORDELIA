; ============
; Create as many GENs as channels
; ============
ich init 1
until ich > nchnls do
	itab ftgen ich, 0, 0, 1, gSfile, 0, 0, ich
	ich += 1
od

giWINDOW ftgen 0, 0, 8192, 20, 4
giSPEED	init 1 ; [idur*ispeed]


gadur init 0

	instr 1
ift			init 1
isamps		ftlen ift
ilen_file 	init isamps/sr
ivoices		init p4
; ============
p3				init ilen_file*giSPEED
idur			init p3
; ============
gadur			= 100 + a(jitter:k(25, 1/idur, 3/idur))
gadur			/= 1000
; ============
gastart			phasor 1/idur
	endin

	instr 2
; ============
; *** INIT ***
; ============
ich			init p4
ift			init p4
isamps		ftlen ift
ilen_file 	init isamps/sr
ivoice_num 	init p5
ivoices		init p6
iphase		divz ivoice_num, ivoices, 0
; ============
; *** VARs ***
; ============
ijitter_samps	init 128
; ============
p3				init ilen_file*giSPEED
idur			init p3
; ============

; ============
; *** READ ***
; ============

aphasor			phasor 1/gadur, iphase

aenv_ph			pow aphasor, 1+abs(lfo(35, 1/k(gadur)/16))
aenv			table aenv_ph, giWINDOW, 1

asum1			= aphasor * samphold:a(gadur, aphasor)
asum2			samphold gastart*(isamps / sr), aphasor
andx			= (asum1+asum2) * sr

aout			table (andx + a(jitter:k(ijitter_samps, 3.5, 5))) % isamps, ift
aout			*= aenv

aout			/= ivoices

	outch ich, aout

	endin

;---SCORE---
/*
voices = 24
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