gknoijt_cps	init 20
ginoijt_choose	init 0
gknoijt_start	init 0
gknoijt_port	init 3

	instr noijt

Sinstr		init "noijt_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

istart		init i(gknoijt_start)

if	istart!=0 then
	istart random 0, i(gknoijt_start)
endif

schedule Sinstr, istart, idur, idyn, ienv, icps, ich

if	ginoijt_choose == 1 then
	gknoijt_cps	= icps
	ginoijt_choose init 0
else
	ginoijt_choose init 1 
endif

	turnoff

	

	instr noijt_instr

Sinstr		init "noijt"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

ilast_freq	init i(gknoijt_cps)
iport		init i(gknoijt_port)

kfreq1_midi_port int cosseg(ftom:i(ilast_freq), (idur/8)*iport, ftom:i(icps))
kfreq2_midi_port int cosseg(ftom:i(ilast_freq), (idur/6)*iport, ftom:i(icps))

kfreq1		cpstun changed2(kfreq1_midi_port), kfreq1_midi_port, gktuning
kfreq2		cpstun changed2(kfreq1_midi_port), kfreq1_midi_port, gktuning

i1div2pi	init $M_PI_4

kpeakdev		= $dyn_var * 2 * i1div2pi
kpeakdev2		= $dyn_var * cosseg(3, idur, 5) * i1div2pi

;STEREO "CHORUS" ENRICHMENT USING JITTER
kjitR			jitter cosseg($M_PI*2, idur, .95), 1.5, 3.5

;MODULATORS
aModulator		oscili	kpeakdev*tablei(line(1, idur/2, 0), ienv, 1), kfreq1 * 7, gitri
aModulator2		oscili	kpeakdev2*tablei(line(1, idur/3, 0), ienv, 1), kfreq2 * 9, gitri

avib1			= lfo(icps/35, icps/250)*expseg(giexpzero, idur, 1)

aCarrierR		phasor	portk(icps + kjitR, idur/48, 20)+avib1
aCarrierR		table3	aCarrierR + aModulator + aModulator2, gisquare, 1, 0, 1
aSigR			= aCarrierR * $dyn_var

aFilterR		bqrez	aSigR, kfreq1+(icps*(16*$dyn_var)), .95*cosseg(1, idur, .5)
aout			balance2 aFilterR, aSigR

	$dur_var(100)
	$end_instr
