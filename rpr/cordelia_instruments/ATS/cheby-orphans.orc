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

k1 = 1 - jitter(2, ibeatf/8, ibeatf)
k2 = 1 - jitter(2, ibeatf/8, ibeatf)
k3 = 1 - jitter(2, ibeatf/8, ibeatf)
k4 = 1 - jitter(2, ibeatf/8, ibeatf)
k5 = 1 - jitter(2, ibeatf/8, ibeatf)
k6 = 1 - jitter(2, ibeatf/8, ibeatf)
k7 = 1 - jitter(2, ibeatf/8, ibeatf)

aout		chebyshevpoly  ain, 0, k1, k2, k3, k4, k5, k6, k7
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