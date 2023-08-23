	instr tlinh

Sinstr		init "tlinh"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

ain		init 1 
kq		= random:i(17, 19)*envgen(idur, ienv)  

astat		oscili $dyn_var/8, 100
aout		diode_ladder ain*$dyn_var, icps, kq, 1, $M_PI
aout		balance2 aout, astat

ienvvar		init idur/$M_PI

	$end_instr

	
