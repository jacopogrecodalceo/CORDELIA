	instr noi

Sinstr		init "noi"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ienvvar		init idur/10
igainfact	init 256

agen		fractalnoise $ampvar, 0


iarr[]		fillarray 32, 24, 48, 96, 64
ichoose		int random(0, lenarray(iarr))
ires		= iarr[ichoose]

anoi		flanger agen*cosseg(1, idur/ires, random:i(.05, .005), idur/ires, 0), cosseg:a(1/icps, idur, .95/icps)*ires, .995

kbw 		= (icps*11/10)-icps 	;bandwidth in Hz

a1		reson anoi, icps, kbw*3
a2		reson anoi, icps*6, kbw

ain		= a1 + a2

aout		= ain/igainfact

;aout		K35_hpf aout, icps, 5.5, 1, 1.35


	$END_INSTR

	endin
