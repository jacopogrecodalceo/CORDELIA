gisaw	ftgen 0, 0, 8192, 7, 1, 8192, -1

	instr 1

;---STANDARD
iatsfile	init p4
ich			init p5

idur			ATSinfo iatsfile, 7
imax_partials	ATSinfo iatsfile, 3

p3		init idur

iamp		init 1
ifreq		init 1
ipartial	int random:i(1, imax_partials)

	kread	line 0, p3, idur

kfreq, kamp		ATSread kread, iatsfile, ipartial

aamp	a  kamp
afreq	a  kfreq*ifreq

i1div2pi		init 1/24

kpeakdev		= aamp * 2 * i1div2pi
kpeakdev2		= aamp * cosseg(3, idur, 5) * i1div2pi

;STEREO "CHORUS" ENRICHMENT USING JITTER
kjitR			jitter cosseg(5, idur, .75), 1.5, 3.5

;MODULATORS
aModulator		oscili	kpeakdev*linseg(0, idur, 1), afreq * 5
aModulator2		oscili	kpeakdev2*cosseg(0, idur, 1), afreq * 2, gisaw

avib1	= lfo(kfreq/32, kfreq/250)*abs(jitter(1, 1/p3, 100/p3))

aCarrierR		phasor	portk(kfreq + kjitR, idur/96, 20)+avib1
aCarrierR		table3	aCarrierR + aModulator + aModulator2, gisaw, 1, 0, 1
aSigR	= aCarrierR * aamp

aFilterR		bqrez	aSigR, afreq+(afreq*(16*aamp)), .75
aout			balance2 aFilterR, aSigR

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