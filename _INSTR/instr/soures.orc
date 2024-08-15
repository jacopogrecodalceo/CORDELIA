#define soures_jit #jitter:k(1/24, .5/p3, 1/p3)#

$start_instr(soures)

	ituning			i gktuning
	ilen_tuning		tab_i 0, ituning
	;iband_low			tab_i 2, ituning
	
	iband_low init icps/2
	until iband_low < ntof("1B") do
		iband_low /= 2 
	od

	iband_high init icps*2
	until iband_high > ntof("7B") do
		iband_high *= 2 
	od

	indx		init 0
	ifreqs[]	init 96
	ifreq_indx	init 0
	ioct		init 1
	until ifreq_indx >= iband_high || indx == lenarray(ifreqs) do
		if indx % ilen_tuning == 0 then
			ioct += 1
		endif

		ifreqs[indx]	= ioct*iband_low * tab_i(4+(indx % ilen_tuning), ituning)
		ifreq_indx		= ifreqs[indx]
		indx += 1
	od

	; Multiple detuned sawtooth waves for a rich sound
	a1	vco2 1, icps, 4, .5+$soures_jit  ; Sawtooth wave
	a2	vco2 1, icps*(1+$soures_jit), 4, .5+$soures_jit  ; Slightly detuned sawtooth wave
	a3	vco2 1, icps*(1-$soures_jit), 4, .5+$soures_jit  ; Another detuned sawtooth wave

	aosc	= fractalnoise(1, 1+$soures_jit*16)/cosseg:a(128, idur, 96) + (a1 + a2 + a3) / 3 

	; FILTER SECTION
	; Low-pass filter to smooth the sound
	
	istart_del		init 1/16;, .05
	imax_del		init istart_del+1/16

	; CHORUS
	adel1			vdelay3 aosc, istart_del+a($soures_jit), imax_del
	adel2			vdelay3 aosc, istart_del+a($soures_jit), imax_del
	adel3			vdelay3 aosc, istart_del+a($soures_jit), imax_del

	adel			= adel1 + adel2 + adel3
	adel			/= pow(1.55, octcps(icps))
	adel			*= $dyn_var

	kbws[]			= ifreqs / cosseg:k(55, idur, 5)
	abands_as[] 	poly indx-1, "butterbp", adel, ifreqs, kbws
	asum 			sumarray abands_as; /pow(2, 12)

	aout = asum*4; + afilter*cosseg:a(1, iatk_filter, .15, idur-iatk_filter, 0));(asum + as / 8) / 2
	;aout = asum; + afilter*cosseg:a(1, iatk_filter, .15, idur-iatk_filter, 0));(asum + as / 8) / 2

	$dur_var(10)
$end_instr
