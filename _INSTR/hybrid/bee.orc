;REQUIRE bee2

gibee_imp	ftgen 0, 0, 0, 1, ---REQUIRED_INSTR_PATH_1---, 0, 0, 0

	instr bee

Sinstr		init "bee"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

;		OSC1
ihard		init $dyn_var	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init $dyn_var	; where the block is hit, in the range 0 to 1

imod		init (ich-1) % gibee2_len
imp			init gibee2_list[imod]

kvrate		expseg random:i(3, 5), idur/2, random:i(.25, .5)/idur
kvdepth		init idyn
ivibfn		init gisine

ai1		gogobel $dyn_var/6, icps, ihard/6, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn

;		OSC2
kc1		cosseg $dyn_var*icps/(idur*50), idur, $dyn_var*icps/(idur*100)
kc2		init 1

ai2		fmbell $dyn_var, icps, kc1, kc2, kvdepth, kvrate+random:i(-.05, .05), gisine, gisine, gisine, gitri, gisine, idur-random:i(0, idur/10)

ishapefn 	init gisaw

ai2   		table3 random:i(.05, .35)*ai2, ishapefn, 1, .5, 1

aout		= ai1 + ai2

$dur_var(10)

	$end_instr

	
