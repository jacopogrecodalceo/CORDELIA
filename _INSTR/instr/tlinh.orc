	instr tlinh

Sinstr		init "tlinh"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

ain		init 1 
kq		= random:i(17, 19)*envgen(idur, iftenv)  

astat		oscili $ampvar/8, 100
aout		diode_ladder ain*$ampvar, icps, kq, 1, $M_PI
aout		balance2 aout, astat

ienvvar		init idur/$M_PI

	$END_INSTR

	endin
