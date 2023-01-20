;almost some drop of water!

gibebois_imp	ftgen 0, 0, 0, 1, "$CORDELIA_DIR/samples/bois.wav", 0, 0, 0

	instr bebois

Sinstr		init "bebois"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

;		OSC1
ihard		init $ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init 1-$ampvar	; where the block is hit, in the range 0 to 1

imp		init gibebois_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $ampvar
ivibfn		init gisine

abel		gogobel $ampvar, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn
arev1		vcomb abel/2, idur*(1+k(envgen(idur, iftenv)*2)), .5/icps, idur
arev2		vcomb abel/3, idur*(1+k(envgen(idur, iftenv)*3)), 1/icps, idur
arev3		vcomb abel/4, idur*(1+k(envgen(idur, iftenv)*4)), 1/(icps*9/8), idur

aout		= abel + arev1/12 + arev2/9 + arev3/7

	$mix

	endin
