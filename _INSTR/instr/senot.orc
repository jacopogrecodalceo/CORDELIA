
	instr senot

Sinstr		init "senot"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

icpsvar		init (icps-(icps*11/10))/6
a1		oscil3 $dyn_var, icps+random:i(-icpsvar, icpsvar), gisine
a2		oscil3 $dyn_var, 3*icps+random:i(-icpsvar, icpsvar), gitri

aout 		= a1 + a2/16

$dur_var(10)

	$END_INSTR

	endin
