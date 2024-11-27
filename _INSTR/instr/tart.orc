; this instrument is created the 26 november after deeply analysing the combination tones of different interval
; the result is this nice vibrato coming from the JI nice m2 interval 16/15, the minor diatonic semitone

	$start_instr(tart)

a1		oscil3 $dyn_var, icps

icps2	init icps*16/15
a2		oscil3 $dyn_var, icps2

icps3	init icps*icps2
while icps3 > icps do
	icps3 /= 2
od
a3		oscil3 $dyn_var, icps3

asum	sum a1, a2, a3*cosseg(0, idur/2, 1, idur/2, 0)

aosc		oscil3 cosseg:a(0, .005, $dyn_var), icps3*floor(cosseg:a(5, idur, 2))
apar_env	linseg 1/(icps-icps3), idur, 1/(icps2-icps)
adel1	flanger aosc, apar_env, .65+random:i(-.15, .15)
adel2	flanger aosc, apar_env/3, .65+random:i(-.15, .15)
adel	sum adel1, adel2

		$dur_var(10)
aout	sum asum, adel*envgen(idur, -int(ienv))/8
aout	/= 3
	$end_instr