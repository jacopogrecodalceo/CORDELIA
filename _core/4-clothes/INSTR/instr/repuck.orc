	instr repuck

Sinstr		init "repuck"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

ipanfreq	init random:i(-.25, .25)

aout	repluck random:i(.015, .35), $ampvar, icps + random:i(-ipanfreq, ipanfreq), randomh:k(.25, .95, random:i(.05, .15)), random:i(.05, .65), poscil(1, random:i(.05, .25),  gisine)
aout	dcblock2 aout
;	ENVELOPE
ienvvar		init idur/10

aout	buthp aout, icps - icps/12

		$death
	endin
