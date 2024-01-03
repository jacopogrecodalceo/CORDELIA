gimhontx_cps	init 20
gkmhontx_port	init 1

	instr mhontx
	$params(mhontx_instr)

schedule Sinstr, 0, idur, idyn, ienv, icps, ich

	turnoff
	endin

	

	instr mhontx_instr
	$params(mhontx)

ilast_freq	init gimhontx_cps
iport		init i(gkmhontx_port)

kfreq1_midi_port int cosseg(ftom:i(ilast_freq), (idur/random:i(4, 8))*iport, ftom:i(icps))
kfreq2_midi_port int cosseg(ftom:i(ilast_freq), (idur/random:i(4, 8))*iport, ftom:i(icps))

kfreq1		cpstun changed2(kfreq1_midi_port), kfreq1_midi_port, gktuning
kfreq2		cpstun changed2(kfreq1_midi_port), kfreq1_midi_port, gktuning

a1		oscil3 $dyn_var, portk(kfreq1, random:i(.005, .035)), gisaw
a2		oscil3 $dyn_var, portk(kfreq2*3/2, random:i(.005, .035)), gitri

aout		= a1 + (a2/4)

ifact		init 24
idyn_fact	init 8
iq		init $dyn_var

amoog_freq	cosseg i(gimhontx_cps)*(ifact+2)*($dyn_var*idyn_fact), idur/2, icps*ifact*($dyn_var*(idyn_fact/6))
amoog_freq	limit amoog_freq, 25, 20$k

aq		cosseg iq, idur, iq*2
aq		limit a1, 0, .9995

aout		moogladder2 aout, amoog_freq, iq

if ich == nchnls then
	gimhontx_cps init icps
endif

	$dur_var(10)
	$end_instr
