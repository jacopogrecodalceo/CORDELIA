; N.B. Path without the last slash / !!!
gSesynth2wave_path init "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samps-esynth2"
gkesynth2wave_jitter init 0

instr esynth2wave_jitter

	gkesynth2wave_jitter jitter 1, gkbeatf/64, gkbeatf/32
	if active:k("esynth2wave") == 0 then
		if timeinstk() > 1 then
			turnoff
		endif
	endif

endin

$start_instr(esynth2wave)

	Sinstr_jitter sprintf "%s_jitter", Sinstr 
	if active:i(Sinstr_jitter) == 0 then
		schedule Sinstr_jitter, 0, -1
	endif

	ipitch_librosa init 179.61
	iratio = icps / ipitch_librosa

	; esynth2wave-001  to 21

	ijit i gkesynth2wave_jitter
	inum_samps init 31
	inum floor 1+abs((octcps(icps) + ijit) % 1)*inum_samps
	Spath1 sprintf "%s/esynth2-%s.wav", gSesynth2wave_path, inum < 10 ? sprintf("00%i", inum) : sprintf("0%i", inum)
/* 	inum init 1+(inum+1) % inum_samps
	Spath2 sprintf "%s/esynth2-%s.wav", gSesynth2wave_path, inum < 10 ? sprintf("00%i", inum) : sprintf("0%i", inum)
	inum init 1+(inum+1) % inum_samps
	Spath3 sprintf "%s/esynth2-%s.wav", gSesynth2wave_path, inum < 10 ? sprintf("00%i", inum) : sprintf("0%i", inum)
 */
	#define esynth2wave_jit #jitter:k(1/32, .5/p3, 1/p3)#
	;prints sprintf("%s\n", Spath )
	; MONOOOOOO

	ain diskin Spath1, iratio, random:i(0, .005)

	; ADD A CODA (generally samps are short)
	ilen init filelen(Spath1) / iratio
	
	aosc init 0
	if idur >= ilen then
		; OSCIL SECTION
		; Multiple detuned sawtooth waves for a rich sound
		a1	vco2 1, icps;, 5  ; Sawtooth wave
		a2	vco2 1, icps*(1+$esynth2wave_jit);, 5  ; Slightly detuned sawtooth wave
		a3	vco2 1, icps*(1-$esynth2wave_jit);, 5  ; Another detuned sawtooth wave

		aosc	= (a1 + a2 + a3) / 3
		aosc	*= cosseg(0, ilen-ilen/4, .35, ilen/4, 1, ilen/4, .5, idur-ilen-(ilen/4)-ilen/4, .15)
	endif

	ares	= ain + aosc

	; FILTER SECTION
	; Low-pass filter to smooth the sound
	kfreq			linseg icps*4, idur / 3, icps*8, idur *  3 / 2, icps  ; Dynamic cutoff
	alow			moogladder2 ares, limit(kfreq, 20, 20$k), random:i(.35, .65)

	ahigh			K35_hpf ares, kfreq, 1+(kfreq/icps*4)*random:i(3, 7.5), 1


	ihigh_time		init 9 - 8 * $dyn_var
	aeq				= (ahigh * cosseg(1, idur / ihigh_time, .5, idur * (ihigh_time - 1) / ihigh_time, 1)) / 4 + (alow * cosseg(1, idur * (ihigh_time - 1) / ihigh_time, .5, idur / ihigh_time, 1))

	; CHORUS
	adel1			vdelay3 aeq, a($esynth2wave_jit), 1/16
	adel2			vdelay3 aeq, a($esynth2wave_jit), 1/16;, 512
	adel3			vdelay3 aeq, a($esynth2wave_jit), 1/16;, 512

	aout			= adel1 + adel2 + adel3
	aout			/= pow(1.55, octcps(icps))
	aout			*= $dyn_var * 32
	aout 			moogladder2 aout, limit(20$k-((1-$dyn_var)*17.5$k)+icps, 20, 20$k), random:i(0, 1/9)

	$dur_var(10)
$end_instr

