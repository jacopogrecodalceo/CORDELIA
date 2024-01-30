gkwutang_vib init 0

	$start_instr(wutang)

ival		init idyn*2

kcps	= icps + vibr(cosseg(.05, idur, icps/4), random:i(idur*2.5, idur*5), gisaw)

kcx1		expseg	idyn, idur, ival
kcx2		cosseg	idyn, idur, ival*idyn

krx1		expseg	idyn, idur/2, ival
krx2		cosseg	ival*idyn, idur, idyn

; FOND
asig		wterrain    $dyn_var, icps+(lfo:k(gkwutang_vib, random:i(3, 5))), kcx1, kcx2, krx1, krx2, gitri, gisine

; HARMs
ifact		init 3
ah1			wterrain    $dyn_var, (kcps*3), kcx1/ifact, kcx2/ifact, krx1/ifact, krx2/ifact, gisaw, gisquare

kdyn		= abs(lfo($dyn_var, cosseg(icps/85, idur, 1/idur)))
ah2			wterrain    kdyn, (icps*4), kcx1/ifact, kcx2/ifact, krx1/ifact, krx2/ifact, gisaw, gisquare

aharms		= ah1 + ah2

aharms		*= cosseg:k(1, idur/2, idyn/4, idur/2, 1)

; FILTRE
aharms		moogladder2 aharms, 7500+((13.5$k)*idyn), limit(kcx1, 0, .95)

aout		= asig + aharms
aout		/= 2

	$dur_var(10)
	$end_instr
