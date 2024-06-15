girhod_fn ftgen 0, 0, 256, 1, "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/fwavblnk.aiff", 0, 0, 0

	$start_instr(rhod)

; fmrhode opcode stops after ~3sec
idur_rhod	init 3

kc1		cosseg $dyn_var*icps/100, idur_rhod, icps/random:i(2, 3) ; Mod index 1
kc2		expseg 1, idur_rhod/2, 1/64 ; Crossfade of two outputs
kvdepth		cosseg 0, idur/2, 1, idur/2, 1
kvrate		looptseg 1/idur_rhod, 0, 0, 3, -2, idur_rhod/2, random:i(3, 4), -4, idur_rhod/2, random:i(9, 12)

ifn1		init gisine
ifn2		init gisine
ifn3		init gisine
ifn4 		init girhod_fn
ivfn		init gisine

afmr		fmrhode $dyn_var, icps, kc1, kc2, kvdepth, kvrate, ifn1, ifn2, ifn3, ifn4, ivfn

; so, for continuity
ituning		i gktuning
ilen		tab_i 0, ituning
ioff		init 4
itun_len	init ilen - ioff

ktun_dec	tab (random:i(0, 1)*(itun_len+1))+ioff, ituning

afmb1		fmb3 $dyn_var, icps, kc1/icps/500, kc2, kvdepth/6, kvrate/int(random:i(1, 4))
afmb2		fmb3 $dyn_var, icps*ktun_dec, kc1/icps/100, kc2, kvdepth/3, kvrate

aout		= afmr + afmb1 + afmb2; + oscili(.25, icps)

	$dur_var(10)
	$end_instr
