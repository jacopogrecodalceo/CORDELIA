gkflou_p1 init 1

	instr flou

Sinstr		init "flou"
idur		init p3
iamp		init p4
iftenv		init p5
icps		init p6
ich		init p7

icps		/= 2

iflou_p1	i gkflou_p1

ijet		init .075+((iamp/16)*iflou_p1)		;Values should be positive, and about 0.3. The useful range is approximately 0.08 to 0.56.
iatk		init .15
idec	 	init .15
inoise_gain	init iamp/3

ivib		init 1/24
;kvibf		= (idur/int(random:i(2, 12)))+cosseg(random:i(-ivib, ivib), idur, 0)

kvibf		= (idur/int(random:i(8, 12)))+cosseg(0, idur, random:i(-ivib, ivib))

kvamp		expseg iamp/6, idur, iamp/2

aorg		wgflute iamp, icps, ijet, iatk, idec, inoise_gain, kvibf, kvamp

af		moogladder2 aorg, icps*(2+(iamp*2)), iamp

asig		= aorg * cosseg:k(0, idur/2, 1, idur/2, 0)
asig		phaser1 asig, 2/icps, 8, .75 
aex		exciter asig, icps*2, icps*8, 3.5+(iamp*4), 3.5+(iamp*8)

aout		= af + (asig/8) + (aex/12)

aout		balance2 aout, aorg

ienvvar		init idur/10

	$death

	endin
