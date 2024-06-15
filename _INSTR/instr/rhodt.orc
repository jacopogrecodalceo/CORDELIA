girhodt_fn ftgen 0, 0, 256, 1, "/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/fwavblnk.aiff", 0, 0, 0

	$start_instr(rhodt)

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

kndx		randomh 0, 1, kvrate*int(random:i(1, 3)), 3

ktun_dec	tab (kndx*(itun_len+1))+ioff, ituning

kvar		init 1
/*
iarr[]		fillarray .5, 1, 1, 1, 2
kvar		init 1

if changed2(ktun_dec) == 1 && random:k(0, 1) > .75 then
	kvar = iarr[random:k(0, lenarray(iarr))]
endif
*/
afmb		fmb3 $dyn_var, portk(icps*ktun_dec*kvar, abs(jitter(.005, 10/idur, 1/idur))), kc1/icps/100, kc2, kvdepth, kvrate

aout		= afmr + afmb; + oscili(.25, icps)

	$dur_var(10)
	$end_instr
