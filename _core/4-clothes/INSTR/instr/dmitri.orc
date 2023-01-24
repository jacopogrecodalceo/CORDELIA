	instr dmitri

Sinstr		init "dmitri"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

anoi		fractalnoise cosseg(iamp, idur, 0), cosseg(0, idur, 2)

asub		resonx anoi, icps, icps/random:i(25, 10)

avco		vco2 cosseg(0, idur, iamp), icps*3/2, 10

asub		balance asub, anoi

apre		= asub + avco/5

iq			init 5

alow, ahigh, aband	svfilter  apre, cosseg(icps*4, idur, icps), iq

ivibfilter1	random 5, 7
ivibfilter2	init ivibfilter1/2

kviblow		cosseg ivibfilter1, idur, ivibfilter1*random:i(.95, 1.05)
kvibhigh	cosseg ivibfilter2, idur, ivibfilter2*random:i(.95, 1.05)

kvibhigh	= kvibhigh * expseg(1, idur/3, 1, idur/3, 2, idur/3, 2)
kviblow		= kviblow * expseg(1, idur/3, 1, idur/3, 2, idur/3, 2)

alow		*= .5 + lfo(.5, kviblow)

ahigh		*= .5 + lfo(.5, kvibhigh)

aout		= alow + ahigh + flanger(aband, expseg:a(giexpzero, idur, random:i(.065, .025)), random:i(.65, .85))

aout		/= 2

;		ENVELOPE
ienvvar		init idur/10

		$death

	endin
