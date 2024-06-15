	$start_instr(noij)

i1div2pi	init 0.1592

kpeakdev		= $dyn_var * 2 * i1div2pi
kpeakdev2		= $dyn_var * cosseg(3, idur, 5) * i1div2pi

;STEREO "CHORUS" ENRICHMENT USING JITTER
kjitR			jitter cosseg(5, idur, .75), 1.5, 3.5

;MODULATORS
if ienv > 0 then
	istart	init 0
	iend	init 1
else
	istart	init 1
	iend	init 0
endif
ienv_abs	abs ienv

aModulator		oscili	kpeakdev*tablei(line(istart, idur/2, iend), ienv_abs, 1), icps * 5, gisine
aModulator2		oscili	kpeakdev2*tablei(line(istart, idur/3, iend), ienv_abs, 1), icps * 2, gitri

avib1			= lfo(icps/35, icps/250)*expseg(giexpzero, idur, 1)

aCarrierR		phasor	portk(icps + kjitR, idur/96, 20)+avib1
aCarrierR		table3	aCarrierR + aModulator + aModulator2, gisaw, 1, 0, 1
aSigR			= aCarrierR * $dyn_var

aFilterR		bqrez	aSigR, icps+(icps*(16*$dyn_var)), .75
aout			balance2 aFilterR, aSigR
aout			dcblock2 aout
	$dur_var(10)
	$end_instr

