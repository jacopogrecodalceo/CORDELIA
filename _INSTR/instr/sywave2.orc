; OSCIL SECTION
#define sywave2_jit #jitter:k(1/32, .5/p3, 1/p3)#

	$start_instr(sywave2)

; Multiple detuned sawtooth waves for a rich sound
a1	vco2 1, icps, 4, .5+$sywave2_jit  ; Sawtooth wave
a2	vco2 1, icps*(1+$sywave2_jit), 4, .5+$sywave2_jit  ; Slightly detuned sawtooth wave
a3	vco2 1, icps*(1-$sywave2_jit), 4, .5+$sywave2_jit  ; Another detuned sawtooth wave

aosc	= (a1 + a2 + a3) / 3

; FILTER SECTION
; Low-pass filter to smooth the sound

ihigh_filter_freq init icps * 4

until ihigh_filter_freq > ntof("7F")*$dyn_var*1.5 do
	ihigh_filter_freq *= 2
od

iatk_filter		init 1/9

until iatk_filter <= idur do
	iatk_filter /= 3
od

kfreq			linseg ihigh_filter_freq, iatk_filter, icps  ; Dynamic cutoff
alow			moogladder2 aosc, limit(kfreq, 20, 20$k), random:i(.35, .65)

; CHORUS
adel1			vdelay3 alow, .025+a($sywave2_jit), 1/16
adel2			vdelay3 alow, .025+a($sywave2_jit), 1/16;, 512
adel3			vdelay3 alow, .025+a($sywave2_jit), 1/16;, 512

aout			= adel1 + adel2 + adel3
aout			/= pow(1.35, octcps(icps))
aout			*= 2

kfilter_dyn		limit 20$k-((linseg:k(0, idur, 1-$dyn_var))*9.5$k)+icps, 20, 20$k
aout 			moogladder2 aout, kfilter_dyn, random:i(0, 1/9)

	$dur_var(10)
	$end_instr