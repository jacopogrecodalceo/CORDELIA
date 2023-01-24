gibee_imp	ftgen 0, 0, 0, 1, "../samples/bee/bee02.wav", 0, 0, 0

	instr bee

Sinstr		init "bee"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

;		OSC1
ihard		init $ampvar	; the hardness of the stick used in the strike. A range of 0 to 1 is used. 0.5 is a suitable value
ipos		init $ampvar	; where the block is hit, in the range 0 to 1

imp		init gibee_imp

kvrate		expseg random:i(3, 5), idur/2, random:i(.25, .5)/idur
kvdepth		init iamp
ivibfn		init gisine

ai1		gogobel $ampvar/6, icps, ihard/6, ipos, imp, kvrate+random:i(-.05, .05), kvdepth, ivibfn

;		OSC2
kc1		cosseg $ampvar*icps/(idur*50), idur, $ampvar*icps/(idur*100)
kc2		init 1

ai2		fmbell $ampvar, icps, kc1, kc2, kvdepth, kvrate+random:i(-.05, .05), gisine, gisine, gisine, gitri, gisine, idur-random:i(0, idur/10)

ishapefn 	init gisaw

ai2   		table3 random:i(.05, .35)*ai2, ishapefn, 1, .5, 1

aout		= ai1 + ai2

ienvvar		init idur/10

	$death

	endin
