giflij_indx	init 1

	instr flij

Sinstr		init "flij_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

iharm[]		fillarray 1, 3/2, 4/5, 9/8, 7/8, 6/5
ilenharm	lenarray iharm

indx init 0
until indx >= giflij_indx do
	schedule Sinstr, 0, idur, idyn/(indx+1), ienv, icps, icps*iharm[floor(indx)], ich
	indx += 1
od

giflij_indx += 1/ginchnls/ginchnls
if giflij_indx >= ilenharm then
	giflij_indx = 1
endif


	turnoff

	

	instr flij_instr

Sinstr		init "flij"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
icps_dest	init p7
ich		init p8

aosc		oscili $dyn_var, icps+(table3:k(phasor:k(1/idur), ienv, 1)*icps_dest), gitri

kfreq		init icps*3/2
kord		init 12*$dyn_var
kfb		cosseg 0, idur, .95

aout		moogladder2 aosc, icps+(icps*($dyn_var*32)), .35
aout		phaser1 aout, kfreq, kord, kfb

$dur_var(4)

	$end_instr

	

