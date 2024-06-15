	instr wendy

Sinstr		init "wendy"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich			init p7

;	gendy kdyn, kdyndist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kdynscl, kdurscl [, initcps] [, knum]

kdyndist	init .075
kdurdist	init .5

kadpar		init .35 ;parameter for the kdyndist distribution. Should be in the range of 0.0001 to 1
kddpar		init .45 ;parameter for the kdurdist distribution. Should be in the range of 0.0001 to 1

kminfreq	init icps-2.5
kmaxfreq	init icps+2.5

kdynscl		init .5 ;multiplier for the distribution's delta value for amplitude (1.0 is full range)
kdurscl		init .45 ;multiplier for the distribution's delta value for duration

initcps		init 16

;	instr
aout	gendy $dyn_var, kdyndist, kdurdist, kadpar, kddpar, kminfreq, kmaxfreq, kdynscl, kdurscl, initcps

;	ENVELOPE
$dur_var(10)

		$end_instr
