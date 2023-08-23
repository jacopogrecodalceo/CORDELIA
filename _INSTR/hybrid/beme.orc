;almost some drop of water!
;REQUIRE chime

gibeme_indx init 0

	instr beme

Sinstr		init "beme"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

if gibeme_indx >= lenarray(gichime_sonvs) then
	gibeme_indx init 0
endif

if ich == 1 then

	gibeme_imp init gichime_sonvs[gibeme_indx]
	
	gibeme_indx += 1	

else

	gibeme_imp init gichime_sonvs[gibeme_indx]

endif	

;		OSC1
ihard		init 1-$dyn_var	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init $dyn_var	; where the block is hit, in the range 0 to 1

imp		init gibeme_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $dyn_var
ivibfn		init gisine

abel		gogobel $dyn_var, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn
arev1		vcomb abel/2, idur*(1+k(envgen(idur, ienv)*2)), .5/icps, idur
arev2		vcomb abel/3, idur*(1+k(envgen(idur, ienv)*3)), 1/icps, idur
arev3		vcomb abel/3, idur*(1+k(envgen(idur, ienv)*4)), 1/(icps*3/2), idur

aout		= abel + arev1/12 + arev2/9 + arev3/7
aout		/= 3
	$CHNMIX

	
