	instr wendi

Sinstr		init "wendi"
idur		init p3
idyn		init p4*.85
ienv		init p5
icps		init p6
ich			init p7

kdyndist	linseg 5, idur, 0
kdurdist	init 2

kadpar		init .995 ;parameter for the kdyndist distribution. Should be in the range of 0.0001 to 1
kddpar		init .75 ;parameter for the kdurdist distribution. Should be in the range of 0.0001 to 1

kvar		cosseg 1, idur, icps/15

kminfreq	= icps-kvar
kmaxfreq	= icps+kvar

;multiplier for the distribution's delta value for amplitude (1.0 is full range)
kdynscl		cosseg .05, idur, 1

;multiplier for the distribution's delta value for duration
kdurscl		cosseg 0, idur, idyn

initcps		init 8+(idyn*48)
knum		cosseg initcps, idur, initcps*.75

;	instr
ai1		gendy $dyn_var, kdyndist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kdynscl, kdurscl, initcps, knum

ai2		oscil $dyn_var, icps*3/random(1.995, 2.005), gisine

ai2		*= expseg(1, idur*.75, giexpzero)

aout	= ai1 + (ai2/2)

;	ENVELOPE
$dur_var(10)

	$end_instr

	
