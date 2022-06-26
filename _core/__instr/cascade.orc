	instr cascade

Sinstr	= "cascade"
idur	init p3*2
iamp	init p4
iftenv	init p5
icps	init p6
ich	init p7
ipan	init icps/100

asquare 		poscil	1, expseg(icps, idur, icps+random:i(-ipan, ipan)), gisquare
asaw			poscil	$ampvar, icps*asquare, gisaw

adel			linseg idur/48, idur, idur*random:i(3.95, 4)

kfb			expseg random:i(.015, .075), idur, random:i(.5, .75)

aout			flanger asaw, adel, kfb
aout			/= 32


;	ENVELOPE
ienvvar			init idur/5

			$death

	endin
