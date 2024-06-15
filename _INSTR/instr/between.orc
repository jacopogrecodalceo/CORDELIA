gkbetween_space	init 1

	instr between_control

gkbetween_mod		init 1
gkbetween_ph		init 0
gkbetween_var	randomi 1.35, 3.25, gkbeatf/24, 3
gkbetween_var	*= gkbetween_mod

	
	alwayson("between_control")

	instr between

Sinstr		init "between"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

istat		init 3
iport		init .85+idyn

icps2		init icps+(idyn*4)

iphase		random 0, i(gkbetween_ph)

kfreq1		loopxseg gkbetween_var, 0, iphase, icps, istat, icps2, iport, icps2*(3/2), istat, icps*(3/2), iport, icps*2, istat, icps2*2, iport
a1		oscil3	$dyn_var, kfreq1, gitri

kfreq2		loopxseg gkbetween_var, 0, iphase*2, icps, istat, icps2, iport, icps2*(3/2), istat, icps*(3/2), iport, icps*2, istat, icps2*2, iport
a2		oscil3	$dyn_var, kfreq2, gisaw

kfreq3		loopxseg gkbetween_var, 0, iphase*2, icps, istat, icps2, iport, icps2*(3/2), istat, icps*(3/2), iport, icps*2, istat, icps2*2, iport
a3		oscil3	$dyn_var, kfreq3*4, gisine
a3		/= 4

af1		flanger a1+a3, a(iport/8), (kfreq1/(icps*2.25))*gkbetween_space
af2		flanger a2+a3, a(iport/6), (kfreq2/(icps*2.25))*gkbetween_space

aout		= a1 + ((a2/2)*scale(idyn*4, 0, 1)) + (af1*cosseg:k(0, idur, 1)) + (af2*cosseg:k(0, idur, 1))
;aout		/= 2

;aout		flanger aout, 10+a(kfreq1/1000), .5

;	ENVELOPE
$dur_var(10)

		$end_instr

	
