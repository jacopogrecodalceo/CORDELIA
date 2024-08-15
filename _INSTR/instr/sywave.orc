#define sywave_jit #jitter:k(1/32, .5/p3, 1/p3)#

	$start_instr(sywave)

; OSCIL SECTION

; Multiple detuned sawtooth waves for a rich sound
a1	vco2 1, icps;, 5  ; Sawtooth wave
a2	vco2 1, icps*(1+$sywave_jit);, 5  ; Slightly detuned sawtooth wave
a3	vco2 1, icps*(1-$sywave_jit);, 5  ; Another detuned sawtooth wave

aosc	= (a1 + a2 + a3) / 3

; FILTER SECTION
; Low-pass filter to smooth the sound
kfreq			linseg icps, idur / 3, icps*4, idur *  3 / 2, icps  ; Dynamic cutoff
alow			moogladder2 aosc, limit(kfreq, 20, 20$k), random:i(.35, .65)

ahigh			K35_hpf aosc, kfreq, 1+(kfreq/icps*4)*random:i(3, 7.5), 1


ihigh_time		init 9 - 8 * $dyn_var
aeq				= (ahigh * cosseg(1, idur / ihigh_time, .5, idur * (ihigh_time - 1) / ihigh_time, 1)) / 4 + (alow * cosseg(1, idur * (ihigh_time - 1) / ihigh_time, .5, idur / ihigh_time, 1))

; CHORUS
adel1			vdelay3 aeq, a($sywave_jit), 1/16
adel2			vdelay3 aeq, a($sywave_jit), 1/16;, 512
adel3			vdelay3 aeq, a($sywave_jit), 1/16;, 512

aout			= adel1 + adel2 + adel3
aout			/= pow(1.55, octcps(icps))
aout			*= $dyn_var * 32
aout 			moogladder2 aout, limit(20$k-((1-$dyn_var)*17.5$k)+icps, 20, 20$k), random:i(0, 1/9)

	$dur_var(10)
	$end_instr