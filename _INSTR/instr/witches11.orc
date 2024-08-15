gkwitches11_mod		init 1 ;mod parameter for witches11 instr
gkwitches11_ndx		init 3 ;index parameter for witches11 instr
gkwitches11_detune	init 0 ;detune parameter for witches11 instr


	instr witches11

Sinstr		init "witches11_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

indx	= i(gkwitches11_ndx)
idetune = i(gkwitches11_detune)

	schedule Sinstr, 0, 								p3, idyn, 		ienv,		icps,					indx, ich
	schedule Sinstr, random:i(p3/16, (p3/16)*2),		p3, idyn/3,		ienv,		(icps*2*11/10)+idetune, 		indx, ich
	schedule Sinstr, random:i(p3/12, (p3/12)*2),		p3, idyn/5,		ienv, 	(icps*3*11/10)+(idetune*2), 	indx, ich

	schedule Sinstr, random:i(p3/5, (p3/5)*2),			p3, idyn/12,	ienv, 	(icps*7*11/10)+(idetune*2), 	indx, ich
	schedule Sinstr, random:i(p3/3, (p3/3)*2),			p3, idyn/16,	ienv, 	(icps*11*11/10)+(idetune*3),	indx, ich

	turnoff
endin


	instr witches11_instr

Sinstr		init "witches11"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
indx		init p7
ich			init p8

kcar 	= int(expseg:k(1, idur, limit(idur, 1, 7)))
amod 	a gkwitches11_mod
kndx	= expseg:k(.05, idur, indx)

aout	foscili $dyn_var, icps+randomi:k(-.05, .05, 1/idur, 2, 0), kcar, amod+randomi:a(-.0015, .0015, 1/idur, 2, 0), kndx+randomi:k(-.05, .05, 1/idur), gisine
aout	/= 7

;	ENVELOPE
$dur_var(10)

	$end_instr

	
