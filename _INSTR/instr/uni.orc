		instr uni

Sinstr		init "uni"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6

;		foscil xamp, kcps, xcar, xmod, kndx, ifn [, iphs]
ivar		init .05
kcar		expon 1, idur, 1+random(-ivar, ivar)
kmod		expon .5, idur, .505
kndx		expon 3.5, idur, idyn
ai1		foscil 	$dyn_var, icps, kcar, kmod, kndx, gisaw
ai2		foscil 	$dyn_var, icps+random(-ivar, ivar), kcar+random(-ivar, ivar), kmod+random(-ivar, ivar), kndx+random(-ivar, ivar), gisaw

;		buzz xamp, xcps, knh, ifn [, iphs]
kbuzzswap	expon   50*idyn, idur, idyn
ai3		buzz   	$dyn_var, icps*1.05, kbuzzswap+random(-idyn, idyn), gisine
ai4		buzz   	$dyn_var, icps*1.05+random(-ivar, ivar), kbuzzswap+random(-idyn, idyn), gisine

a1		= ai1 + ai3
a2		= ai2 + ai4

;		ENVELOPE
$dur_var(10)

$ENVGEN1
$ENVGEN2

;		ROUTING
S1		sprintf	"%s-1", Sinstr
S2		sprintf	"%s-2", Sinstr

		chnmix a1, S1
		chnmix a2, S2

		
