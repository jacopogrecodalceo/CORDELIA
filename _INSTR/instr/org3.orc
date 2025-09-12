giorg3_val[] fillarray 6, 3, 5

	$start_instr(org3)

ilen	int random:i(3, 7)
ival[]	init ilen

indx init 0
while indx < ilen do
	ival[indx] = giorg3_val[random:i(0, lenarray(giorg3_val))]
	indx += 1
od

kc1		cosseg 5, idur, icps%7.5
kc2		= 5-jitter(3.5, .125/idur, 1/idur) 
kvrate	= gkbeatf*ival[cosseg(0, idur, ilen-1)]
kvdpth	cosseg 0, idur, icps%.395+random:i(0, .075)

aout	fmb3 $dyn_var, icps, kc1, kc2, kvdpth, kvrate
aout	butterhp aout, 20
aout 	/= 2

	$dur_var(10)
	$end_instr

