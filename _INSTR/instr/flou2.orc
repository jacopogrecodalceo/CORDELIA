gkflou2_p1 init 1

	$start_instr(flou2)

iflou2_p1	i gkflou2_p1

ijet		init .075+((idyn/16)*iflou2_p1)		;Values should be positive, and about 0.3. The useful range is approximately 0.08 to 0.56.
iatk		init idur/24
idec	 	init idur/9
inoise_gain	init idyn/3

ivib		init 1/24
;kvibf		= (idur/int(random:i(2, 12)))+cosseg(random:i(-ivib, ivib), idur, 0)

kvibf		= (idur/int(random:i(8, 12)))+cosseg(0, idur, random:i(-ivib, ivib))

kvamp		cosseg idyn/6, idur, idyn/2

aorg		wgflute idyn, icps, ijet, iatk, idec, inoise_gain, kvibf, kvamp

af		moogladder2 aorg, icps*(2+(idyn*2)), idyn

asig		= aorg * cosseg:k(0, idur/2, 1, idur/2, 0)
asig		phaser1 asig, 2/icps, 8, .75 
aex			exciter asig, icps*2, icps*8, 3.5+(idyn*4), 3.5+(idyn*8)

aout		= af + (asig/8) + (aex/12)

aout		balance2 aout, aorg

	$dur_var(10)
	$end_instr

