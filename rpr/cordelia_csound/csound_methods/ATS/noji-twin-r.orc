gisaw	ftgen 0, 0, 8192, 7, 1, 8192, -1

	instr 1

Satsfile		init p4
ich				init p5
imax_p			ATSinfo Satsfile, 3
gidur			ATSinfo Satsfile, 7

inum			init 31

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
idur			init gidur
p3				init idur
Satsfile		init p4
ich				init p5
ipartial		init p6
iamp			init 1
ifreq			init 1

; ============
; *** READ ***
; ============
kread 			line 0, p3, idur
kfreq, kdyn		ATSread kread, Satsfile, ipartial
adyn			a kdyn
afreq			a kfreq

; ============
; *** CORE ***
; ============
i1div2pi		init 1/24

kpeakdev		= kdyn * 2 * i1div2pi
kpeakdev2		= kdyn * cosseg(3, idur, 5) * i1div2pi

;stereo "chorus" enrichment using jitter
kjit_r			jitter cosseg(5, idur, .75), 1.5, 3.5

;modulators
a_modulator1		oscili	kpeakdev*linseg(0, idur, 1), afreq * 5
a_modulator2		oscili	kpeakdev2*cosseg(0, idur, 1), afreq * 2, gisaw

avib1			= lfo(kfreq/32, kfreq/250)*abs(jitter(1, 1/p3, 100/p3))

a_carrier_r		phasor	portk(kfreq + kjit_r, idur/96, 20)+avib1
a_carrier_r		table3	a_carrier_r + a_modulator + a_modulator2, gisaw, 1, 0, 1
a_sig_r			= a_carrier_r * adyn

a_filter_r		bqrez	a_sig_r, afreq+(afreq*(16*adyn)), .75
aout			balance2 a_filter_r, a_sig_r


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
