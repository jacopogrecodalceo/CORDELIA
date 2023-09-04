gkmhont2_cps	init 20
gimhont2_choose	init 0
gkmhont2_start	init 0
gkmhont2_port	init 1

	instr mhont2

Sinstr		init "mhont2_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

istart		init i(gkmhont2_start)

if	istart!=0 then
	istart random 0, i(gkmhont2_start)
endif

schedule Sinstr, istart, idur, idyn, ienv, icps, ich

if	gimhont2_choose == 1 then
	gkmhont2_cps	= icps
	gimhont2_choose init 0
else
	gimhont2_choose init 1 
endif

	turnoff
	endin
	

	instr mhont2_instr

Sinstr		init "mhont2"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

ilast_freq	init i(gkmhont2_cps)
iport		init i(gkmhont2_port)

kfreq1_midi_port int cosseg(ftom:i(ilast_freq), (idur/8)*iport, ftom:i(icps))
kfreq2_midi_port int cosseg(ftom:i(ilast_freq), (idur/6)*iport, ftom:i(icps))

if changed2(gimhont2_choose) == 1 && changed2(kfreq1_midi_port) == 1 then
	kfreq1_midi_port = kfreq1_midi_port
endif

if changed2(gimhont2_choose) == 0 && changed2(kfreq1_midi_port) == 1 then
	kfreq1_midi_port = kfreq1_midi_port
endif

kfreq1		cpstun changed2(kfreq1_midi_port), kfreq1_midi_port, gktuning
kfreq2		cpstun changed2(kfreq1_midi_port), kfreq1_midi_port, gktuning

a1		oscil3 $dyn_var, portk(kfreq1, random:i(.005, .035)), gisaw
a2		oscil3 $dyn_var, portk(kfreq2*3/2, random:i(.005, .035)), gitri

aout		= a1 + (a2/4)

ifact		init 24
idyn_fact	init 8
iq		init $dyn_var

amoog_freq	cosseg i(gkmhont2_cps)*(ifact+2)*($dyn_var*idyn_fact), idur/2, icps*ifact*($dyn_var*(idyn_fact/6))
amoog_freq	limit amoog_freq, 25, 20$k

aq		cosseg iq, idur, iq*2
aq		limit a1, 0, .9995

aout		moogladder2 aout, amoog_freq, iq

	$dur_var(10)
	$end_instr
