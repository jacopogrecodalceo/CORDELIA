	instr wendi

Sinstr		init "wendi"
idur		init p3
iamp		init p4*.85
iftenv		init p5
icps		init p6
ich			init p7

kampdist	linseg 5, idur, 0
kdurdist	init 2

kadpar		init .995 ;parameter for the kampdist distribution. Should be in the range of 0.0001 to 1
kddpar		init .75 ;parameter for the kdurdist distribution. Should be in the range of 0.0001 to 1

kvar		cosseg 1, idur, icps/15

kminfreq	= icps-kvar
kmaxfreq	= icps+kvar

;multiplier for the distribution's delta value for amplitude (1.0 is full range)
kampscl		cosseg .05, idur, 1

;multiplier for the distribution's delta value for duration
kdurscl		cosseg 0, idur, iamp

initcps		init 8+(iamp*48)
knum		cosseg initcps, idur, initcps*.75

;	instr
ai1		gendy $ampvar, kampdist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kampscl, kdurscl, initcps, knum

ai2		oscil $ampvar, icps*3/random(1.995, 2.005), gisine

ai2		*= expseg(1, idur*.75, giexpzero)

aout	= ai1 + (ai2/2)

;	ENVELOPE
ienvvar		init idur/10

	$death

	endin
