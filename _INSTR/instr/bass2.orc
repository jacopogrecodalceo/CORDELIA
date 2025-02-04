	$start_instr(bass2)

a1    	oscil3 $dyn_var*2, icps, gisine
a2    	oscil3 $dyn_var*cosseg:a(0, idur*15/16, 1/2, idur/16, 0), cosseg(icps*11/10, idur/8, icps), gisine
;ares buzz xamp, xcps, knh, ifn [, iphs]

a3		oscil3 $dyn_var/pow(2, 9)*cosseg:a(0, idur/3, 1), icps*2, gisaw
a4		oscil3 $dyn_var/pow(2, 8)*cosseg:a(0, idur/4, 1, idur*3/4, 0), icps*3, gitri

anoi		fractalnoise $dyn_var, 1
a5			K35_lpf anoi, icps*2, 5.35, 1, 3.25

aout	sum a1, a2, a3, a4, a5/pow(2, 8)*cosseg:a(0, idur, 1)

isub_cps	init icps
while (isub_cps / 2) > 20 do
	isub_cps /= 2
od

aout	+= oscil3($dyn_var*2, isub_cps, gisine)

;aout	butterhp aout, 20, .5

	$dur_var(50)
	$end_instr   