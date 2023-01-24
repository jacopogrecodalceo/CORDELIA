gkwutang_vib init 0

	instr wutang

Sinstr		init "wutang"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

ival		init iamp*2

kcps	= icps + vibr(cosseg(.05, idur, icps/4), random:i(idur*2.5, idur*5), gisaw)

kcx1		expseg	iamp, idur, ival
kcx2		cosseg	iamp, idur, ival*iamp

krx1		expseg	iamp, idur/2, ival
krx2		cosseg	ival*iamp, idur, iamp

;		FOND
asig		wterrain    $ampvar, icps+(lfo:k(gkwutang_vib, random:i(3, 5))), kcx1, kcx2, krx1, krx2, gitri, gisine

;		HARMs
ifact		init 3
ah1		wterrain    $ampvar, (kcps*3), kcx1/ifact, kcx2/ifact, krx1/ifact, krx2/ifact, gisaw, gisquare

kamp		= abs(lfo($ampvar, cosseg(icps/85, idur, 1/idur)))
ah2		wterrain    kamp, (icps*4), kcx1/ifact, kcx2/ifact, krx1/ifact, krx2/ifact, gisaw, gisquare

aharms		= ah1 + ah2

aharms		*= cosseg:k(1, idur/2, iamp/4, idur/2, 1)

;		FILTRE
aharms		moogladder2 aharms, 7500+((13.5$k)*iamp), limit(kcx1, 0, .95)

aout		= asig + aharms
aout		/= 2

ienvvar		init idur/10

	$death

	endin
