	instr skij

Sinstr		init "skij"
idur		init p3
idyn		init p4/2
ienv		init p5
icps		init p6
ich		init p7

kharm		init 9+($dyn_var*3)
klowh		init 5
kmul		expseg 1, idur/3, 1, idur/3, 7, idur/3, 1
iphs		random 0, 1

aout		gbuzz $dyn_var/kharm, limit(cosseg(icps/2, idur/64, icps), 20, 20$k)+(lfo(icps/96, 3/idur)*cosseg(0, idur/2, .005, idur/2, 1)), kharm, klowh, kmul, gisine, iphs		

aout		/= cosseg(32, p3, 1)

$dur_var(10)

	$end_instr

	
