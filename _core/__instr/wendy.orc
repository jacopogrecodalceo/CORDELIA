	instr wendy

Sinstr		init "wendy"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich			init p7

;	gendy kamp, kampdist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kampscl, kdurscl [, initcps] [, knum]

kampdist	init .075
kdurdist	init .5

kadpar		init .35 ;parameter for the kampdist distribution. Should be in the range of 0.0001 to 1
kddpar		init .45 ;parameter for the kdurdist distribution. Should be in the range of 0.0001 to 1

kminfreq	init icps-2.5
kmaxfreq	init icps+2.5

kampscl		init .5 ;multiplier for the distribution's delta value for amplitude (1.0 is full range)
kdurscl		init .45 ;multiplier for the distribution's delta value for duration

initcps		init 16

;	instr
aout	gendy $ampvar, kampdist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kampscl, kdurscl, initcps

;	ENVELOPE
ienvvar		init idur/10

		$death

	endin
