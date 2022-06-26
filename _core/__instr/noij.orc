	instr noij

Sinstr		init "noij"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

i1div2pi	init 0.1592

kpeakdev		= $ampvar * 2 * i1div2pi
kpeakdev2		= $ampvar * cosseg(3, idur, 5) * i1div2pi

;STEREO "CHORUS" ENRICHMENT USING JITTER
kjitR			jitter cosseg(5, idur, .75), 1.5, 3.5

;MODULATORS
aModulator		oscili	kpeakdev*tablei(line(1, idur/2, 0), iftenv, 1), icps * 5, gisine
aModulator2		oscili	kpeakdev2*tablei(line(1, idur/3, 0), iftenv, 1), icps * 2, gitri

avib1			= lfo(icps/35, icps/250)*expseg(giexpzero, idur, 1)

aCarrierR		phasor	portk(icps + kjitR, idur/96, 20)+avib1
aCarrierR		table3	aCarrierR + aModulator + aModulator2, gisaw, 1, 0, 1
aSigR			= aCarrierR * $ampvar

aFilterR		bqrez	aSigR, icps+(icps*(16*$ampvar)), .75
aout			balance2 aFilterR, aSigR

ienvvar			init idur/10

	$death

	endin

