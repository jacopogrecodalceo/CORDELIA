;almost some drop of water!
;REQUIRE bois

	$start_instr(beboiv)

idyn_fact	init 1

;		OSC1
ihard		init 1-$dyn_var	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init $dyn_var	; where the block is hit, in the range 0 to 1

imod		init (ich-1) % gibois_len
imp		init gibois_list[imod]

kvrate		expseg 5, idur, 15/idur
kvdepth		cosseg 1, idur, $dyn_var
ivibfn		init gisine

abel		gogobel $dyn_var, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn

arev1		vcomb abel/2, idur*(1+k(envgen(idur, ienv)*2)), .5/icps, idur
arev2		vcomb abel/3, idur*(1+k(envgen(idur, ienv)*3)), 1/icps, idur
arev3		vcomb abel/4, idur*(1+k(envgen(idur, ienv)*4)), 1/(icps*11/10), idur

aout		= abel + arev1/7 + arev2/5 + arev3/3; + oscili(1/512, icps*3)

aout		= aout*(abs(lfo:a(1, 3+random:i(-.05, .05)))*cosseg(0, idur/3, 1))+aout*cosseg(1, idur/3, 0)
aout		*= idyn_fact

	$channel_mix
	endin


	
