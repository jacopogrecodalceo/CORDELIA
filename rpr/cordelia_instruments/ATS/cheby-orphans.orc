	instr 1

;---STANDARD
iatsfile	init p4
ich			init p5

idur			ATSinfo iatsfile, 7
imax_partials	ATSinfo iatsfile, 3

p3	init idur

iamp		init 1
ifreq		init 1
ipartial	int random:i(1, imax_partials)

kread 		line 0, p3, idur

kfreq, kamp ATSread kread, iatsfile, ipartial

aamp        a  kamp
afreq       a  kfreq

ain 		oscili iamp*kamp, afreq*ifreq

ibeatf = p3/64

#define jit #1 - jitter(2, ibeatf/8, ibeatf)#

aout		chebyshevpoly  ain, 0, $jit, $jit, $jit, $jit, $jit, $jit, $jit
aout		balance2 aout, ain
aout		dcblock2 aout
	outch ich, aout
	
	endin

;---SCORE---
/* 
for i in range(31):
	code = [
		'i1',
		0,			# p2: when
		1,			# p3: dur
		ats_file,	# p4
		ch			# p5
	]
	score.append(' '.join(map(str, code)))
*/