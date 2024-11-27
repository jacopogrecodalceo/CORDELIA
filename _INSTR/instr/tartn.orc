; this instrument is created the 26 november
; with the undecimal neutral third

gktartn_vibfreq init 15

	$start_instr(tartn)

icps2	init icps*11/9

icps3	init icps*icps2
while icps3 > icps do
	icps3 /= 2
od

ivib1	init icps-icps3
ivib2	init icps2-icps
while ivib2 > 3 do
	ivib2 /= 2
od

avib1 lfo cosseg(1/12, idur, 1/2), cosseg(ivib1+random:i(-.05, .05), idur*8/9, ivib1+random:i(-.05, .05), idur/9, ivib1+random:i(-.05, .05)*4)
avib2 lfo cosseg(1/24, idur, 1/2), ivib2+random:i(-.05, .05)
avib3 lfo cosseg(0, idur/2, 1/64, idur/2, 1/2), gktartn_vibfreq

a1		oscil3 $dyn_var, icps, gitri
a2		oscil3 $dyn_var, icps2, gisaw

aout	sum a1, a2
aout	*= 1/2 + avib1 + avib2
aout	*= 1/2 + avib3
aout	/= 3

	$dur_var(10)
	$end_instr