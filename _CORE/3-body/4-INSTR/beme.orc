;almost some drop of water!

gibeme_indx init 0

	instr beme

Sinstr		init "beme"
idur		init p3
iamp		init p4
iftenv		init p5
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
ihard		init 1-$ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init $ampvar	; where the block is hit, in the range 0 to 1

imp		init gibeme_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $ampvar
ivibfn		init gisine

abel		gogobel $ampvar, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn
arev1		vcomb abel/2, idur*(1+k(envgen(idur, iftenv)*2)), .5/icps, idur
arev2		vcomb abel/3, idur*(1+k(envgen(idur, iftenv)*3)), 1/icps, idur
arev3		vcomb abel/3, idur*(1+k(envgen(idur, iftenv)*4)), 1/(icps*3/2), idur

aout		= abel + arev1/12 + arev2/9 + arev3/7
aout		/= 3
	$mix

	endin
