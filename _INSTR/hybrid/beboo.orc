;almost some drop of water!
;REQUIRE bois

	instr beboo

Sinstr		init "beboo"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

;		OSC1
ihard		init $dyn_var	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init 1-$dyn_var	; where the block is hit, in the range 0 to 1

imod		init (ich-1) % gibois_len
imp			init gibois_list[imod]

kvrate		expseg 3, idur, 12/idur
kvdepth		init $dyn_var
ivibfn		init gisine

abel		gogobel $dyn_var, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn
adel		flanger abel, idur/(icps/100+((icps/250)*envgen(idur, ienv))), $dyn_var

aout		= adel

	$CHNMIX

	
