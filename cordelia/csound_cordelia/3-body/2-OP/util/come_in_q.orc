	opcode come_in_q, k, i
	itime xin

if itime > 0 then
	istart		init 0
	iend		init 1
else
	istart		init 1
	iend		init 0
endif

itime		abs itime

kndx		init 0
kres		init 0
kval		init istart

kgate		= gkbeatn

kramp	 	cosseg istart, itime, iend
kval		samphold kramp, changed2(kgate), istart

if changed2(kval) == 1 then

	kperc	= ((kval-istart)/(iend-istart))*100

	printks2 "→ ⏳, \033[91m\033[1m%i%%\033[0m, ", kperc
	printks2 "%0.2f\n", kval

	xout kval
endif

	endop



	opcode come_in_q, k, iii
	istart, itime, iend xin

if itime > 0 then
	istart		init istart
	iend		init iend
else
	istart		init iend
	iend		init istart
endif

itime		abs itime

kndx		init 0
kres		init 0
kval		init istart

kgate		= gkbeatn

kramp	 	cosseg istart, itime, iend
kval		samphold kramp, changed2(kgate), istart

if changed2(kval) == 1 then
	kperc	= ((kval-istart)/(iend-istart))*100

	printks2 sprintf("%0.2f to %0.2f → ⏳", istart, iend), kval
	printks2 "\033[91m\033[1m%i%%\033[0m, ", kperc
	printks2 "%0.2f\n", kval

	xout kval
endif

	endop

