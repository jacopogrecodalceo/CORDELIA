	instr 1

Satsfile		init p4
ich				init p5
Sfile			init p6

imax_p			ATSinfo Satsfile, 3
gidur			ATSinfo Satsfile, 7

itab			ftgen ich, 0, 0, 1, Sfile, 0, 0, ich

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
ifreq			init 1

; ============
; *** READ ***
; ============
kread 			line 0, p3, gidur
kfreq, kamp		ATSread kread, Satsfile, ipartial
kffreq			samphold kfreq*ifreq, kamp / 4

; ============
; *** CORE ***
; ============
as				table3 a(kread)/gidur, ich, 1
an				vco2 kamp, kfreq*ifreq

aband_s			butterbp as, kffreq, 25
aband_s			butterbp aband_s, kffreq, 5
aband_n			butterbp an, kffreq, 5

aout			balance aband_s, aband_n
aout			*= 1 - (kamp / 4)
;aout			dcblock2 aband

; ============
; *** aOUT ***
; ============
	outch ich, aout / 4
	
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
		f'"{input_file_wav}"' # p6
	]
	score.append(' '.join(map(str, code)))
*/