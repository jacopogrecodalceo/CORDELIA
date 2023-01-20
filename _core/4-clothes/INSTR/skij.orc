	instr skij

Sinstr		init "skij"
idur		init p3
iamp		init p4/2
iftenv		init p5
icps		init p6
ich		init p7

kharm		init 9+($ampvar*3)
klowh		init 5
kmul		expseg 1, idur/3, 1, idur/3, 7, idur/3, 1
iphs		random 0, 1

aout		gbuzz $ampvar/kharm, limit(cosseg(icps/2, idur/64, icps), 20, 20$k)+(lfo(icps/96, 3/idur)*cosseg(0, idur/2, .005, idur/2, 1)), kharm, klowh, kmul, gisine, iphs		

aout		/= cosseg(32, p3, 1)

ienvvar		init idur/10

	$death

	endin
