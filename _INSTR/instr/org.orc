	$start_instr(org)

ival[]	fillarray 6, 6, 3, 4

kc1	= 5
kc2	= 5
kvrate	= gkbeatf*ival[linseg(0, idur, lenarray(ival))]
kvdpth	cosseg 0, idur, .15

aout	fmb3 $dyn_var, icps, kc1, kc2, kvdpth, kvrate
aout	dcblock2 aout
	$dur_var(10)
	$end_instr

