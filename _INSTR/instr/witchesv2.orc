gkwitchesv2_mod		init 1 ;mod parameter for witchesv2 instr
gkwitchesv2_ndx		init 3 ;index parameter for witchesv2 instr
gkwitchesv2_detune	init 0 ;detune parameter for witchesv2 instr


	instr witchesv2

Sinstr		init "witchesv2_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

icps2		init (icps*16/9)/2

indx	= i(gkwitchesv2_ndx)
idetune = i(gkwitchesv2_detune)

	schedule Sinstr, 0, 									idur, idyn, 		ienv,		(icps+(icps2*0)),					indx, ich
	schedule Sinstr, random:i(idur/16, (idur/16)*2),		idur, idyn/3,		ienv,		(icps+(icps2*1))+idetune,			indx, ich
	schedule Sinstr, random:i(idur/12, (idur/12)*2),		idur, idyn/5,		ienv, 		(icps+(icps2*2))+(idetune*2), 		indx, ich

	schedule Sinstr, random:i(idur/5, (idur/5)*2),			idur, idyn/12,		ienv, 		(icps+(icps2*3))+(idetune*2), 		indx, ich
	schedule Sinstr, random:i(idur/3, (idur/3)*2),			idur, idyn/16,		ienv, 		(icps+(icps2*4))+(idetune*3),		indx, ich

	turnoff
	endin

	

	instr witchesv2_instr

Sinstr		init "witchesv2"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
indx		init p7
ich			init p8

kcar 	= int(expseg:k(1, idur, limit(idur, 1, 7)))
amod 	a gkwitchesv2_mod
kndx	= expseg:k(1.05, idur, 1+indx)-1

aout	foscili $dyn_var, icps+randomi:k(-.05, .05, 1/idur, 2, 0), kcar, amod+randomi:a(-.0015, .0015, 1/idur, 2, 0), kndx+randomi:k(-.05, .05, 1/idur), gisine

	$dur_var(10)
	$end_instr
