	instr cascadexp_instr

Sinstr	= "cascadexp"

idur	init p3
iamp	init p4
iftenv	init p5
icps	init p6
ich		init p7
ipan	init icps/95

iamp	init $ampvar

;			1st harmonic
asquare 		poscil	1, expseg(icps, idur, icps+random:i(-ipan, ipan)), gisquare
asaw			poscil	iamp, icps*asquare, gisine

;			2nd harmonic
aharm_mod		poscil	1, expseg(icps, idur, icps+random:i(-ipan, ipan)*4), gitri
aharm2_out		poscil	iamp/32, icps*aharm_mod*7, gisquare

;			3rd harmonic
i1multi3		init 2
a2multi3		cosseg 24, idur, 12
kharm3amp		expseg 12, idur, 32

aharm3_mod		poscil	1, expseg(icps, idur, icps+random:i(-ipan, ipan)*i1multi3), gisquare
aharm3_out		poscil	iamp/kharm3amp, icps*aharm_mod*a2multi3, gisquare

;			total
asyn			=	asaw + aharm2_out + aharm3_out

adel			expseg random:i(.0015, .0075), idur, random:i(.075, .0075)

kfb				expseg random:i(.75, .705), idur, random:i(.15, .25)

aout			flanger asyn, adel, kfb	

aout			buthp aout, icps - icps/12

;	ENVELOPE
ienvvar		init idur/5

			$death

	endin

	instr cascadexp

Sinstr	= "cascadexp_instr"

iarp	init .0125
idur	init p3
iamp	init p4
iftenv	init p5
icps	init p6
ich		init p7

	schedule Sinstr, random:i(0, iarp),	idur, iamp, iftenv, icps, ich
	schedule Sinstr, random:i(0, iarp),	idur, iamp, iftenv, icps, ich
	schedule Sinstr, random:i(0, iarp),	idur, iamp, iftenv, icps, ich

	turnoff

	endin
