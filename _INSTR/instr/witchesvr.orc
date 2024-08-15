gkwitchesvr_mod		init 1 ;mod parameter for witchesvr instr
gkwitchesvr_ndx		init 3 ;index parameter for witchesvr instr
gkwitchesvr_detune	init 0 ;detune parameter for witchesvr instr


	instr witchesvr

Sinstr		init "witchesvr_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

icps2		init (icps*11/10)

indx	= i(gkwitchesvr_ndx)
idetune = i(gkwitchesvr_detune)

	schedule Sinstr, 0, 									idur, idyn, 		ienv,		icps,							indx, ich, 0
	schedule Sinstr, random:i(idur/16, (idur/16)*2),		idur, idyn/3,		ienv,		icps+idetune, 					indx, ich, icps2
	schedule Sinstr, random:i(idur/12, (idur/12)*2),		idur, idyn/5,		ienv, 		icps+icps2+(idetune*2), 			indx, ich, 0

	schedule Sinstr, random:i(idur/5, (idur/5)*2),			idur, idyn/12,		ienv, 		icps+(idetune*4), 				indx, ich, icps2*4
	schedule Sinstr, random:i(idur/3, (idur/3)*2),			idur, idyn/16,		ienv, 		icps+(icps2*4)+(idetune*3),		indx, ich, 0

	turnoff
	endin

	

	instr witchesvr_instr

Sinstr		init "witchesvr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
indx		init p7
ich			init p8
iring		init p9

kcar 	= int(expseg:k(1, idur, limit(idur, 1, 7)))
amod 	a gkwitchesvr_mod
kndx	= expseg:k(1.05, idur, 1+indx)-1

aout	foscili $dyn_var, icps+jitter:k(.05, 1/idur, 4/idur), kcar, amod+a(jitter:k(.0015, 1/idur, 4/idur)), kndx+jitter:k(.05, 1/idur, 4/idur), gisine
aout	/= 7

if iring > 0 then
	aout	*= oscili:a(1, iring)
endif

	$dur_var(10)
	$end_instr
