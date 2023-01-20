;almost some drop of water!

gibeboo_imp	ftgen 0, 0, 0, 1, "$CORDELIA_DIR/samples/bois.wav", 0, 0, 0

	instr beboo

Sinstr		init "beboo"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

;		OSC1
ihard		init $ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init 1-$ampvar	; where the block is hit, in the range 0 to 1

imp		init gibeboo_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $ampvar
ivibfn		init gisine

abel		gogobel $ampvar, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn
adel		flanger abel, idur/(icps/100+((icps/250)*envgen(idur, iftenv))), $ampvar

aout		= adel

	$mix

	endin
