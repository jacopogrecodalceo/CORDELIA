gibecapr_imp1	ftgen 0, 0, 0, 1, "$CORDELIA_DIR/samples/capr2x/capr2x-006.wav", 0, 0, 0
gibecapr_imp2	ftgen 0, 0, 0, 1, "$CORDELIA_DIR/samples/capr2x/capr2x-007.wav", 0, 0, 0
gibecapr_imp3	ftgen 0, 0, 0, 1, "$CORDELIA_DIR/samples/capr2x/capr2x-008.wav", 0, 0, 0

gibecapr_indx	init 0
gibecapr_arr[]	fillarray gibecapr_imp1, gibecapr_imp2, gibecapr_imp3

	instr becapr

Sinstr		init "becapr"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

if gibecapr_indx >= lenarray(gibecapr_arr) then
	gibecapr_indx init 0
endif

if ich == 1 then

	gibecapr_imp init gibecapr_arr[gibecapr_indx]
	
	gibecapr_indx += 1

else

	gibecapr_imp init gibecapr_arr[gibecapr_indx]
	
endif

;		OSC1
ihard		init $ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init $ampvar	; where the block is hit, in the range 0 to 1

imp		init gibecapr_imp

kvrate		expseg 3, idur, 12/idur
kvdepth		init $ampvar
ivibfn		init gitri

abel		gogobel $ampvar, icps, ihard, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn

aout		= abel/8

	$mix

	endin
