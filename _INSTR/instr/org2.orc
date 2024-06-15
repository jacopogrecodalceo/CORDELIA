giorg2_val[] fillarray 6, 3, 4, 1, 1.5

	$start_instr(org2)

ilen	int random:i(4, 8)
ival[]	init ilen

indx init 0
while indx < ilen do
	ival[indx] = giorg2_val[random:i(0, lenarray(giorg2_val))]
	indx += 1
od

kc1	cosseg 5, idur, 7.5
kc2	= 5-jitter(3.5, .125/idur, 1/idur) 
kvrate	= gkbeatf*ival[cosseg(0, idur, ilen-1)]
kvdpth	cosseg 0, idur, .075

aout	fmb3 $dyn_var, icps, kc1, kc2, kvdpth, kvrate
aout	dcblock2 aout
aout /= 2
	$dur_var(10)
	$end_instr

