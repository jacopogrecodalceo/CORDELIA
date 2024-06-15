gimaij2_indx	init 1

	instr maij2

Sinstr		init "maij2_instr"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
ich		init p7

iharm[]		fillarray 1, 3/2, 4/5, 9/8, 7/8, 6/5
ilenharm	lenarray iharm

indx init 0
until indx >= gimaij2_indx do
	schedule Sinstr, 0, idur, idyn/(indx+1), ienv, icps, icps*iharm[floor(indx)], ich
	indx += 1
od

gimaij2_indx += 1/ginchnls/ginchnls
if gimaij2_indx >= ilenharm then
	gimaij2_indx = 1
endif


	turnoff

	

	instr maij2_instr

Sinstr		init "maij2"
idur		init p3
idyn		init p4
ienv		init p5
icps		init p6
icps_dest	init p7
ich		init p8

aosc		vco2 $dyn_var, icps+(table3:k(phasor:k(1/idur), ienv, 1)*icps_dest)

kfreq		init icps*3/2
kord		init 12*$dyn_var
kfb		cosseg 0, idur, .95

aout		moogladder2 aosc, icps+(icps*($dyn_var*24)), .35
aout		phaser1 aout, kfreq, kord, kfb

$dur_var(4)

	$end_instr

	

