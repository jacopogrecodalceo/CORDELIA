	opcode come_in_s, k, i
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
kval		init 0

kgate		= gkbeatn

kval	 	cosseg istart, itime, iend

if changed2(kgate) == 1 then
	kperc	= ((kval-istart)/(iend-istart))*100

	printks2 "→ ⏳, \033[91m\033[1m%i%%\033[0m, ", kperc
	printks2 "%0.2f\n", kval
endif

	xout kval


	endop



	opcode come_in_s, k, iii
	istart, itime, iend xin

if itime > 0 then
	istart		init istart
	iend		init iend
else
	istart		init iend
	iend		init istart
endif

itime		abs itime

kgate		= gkbeatn

kval	 	cosseg istart, itime, iend

if changed2(kgate) == 1 then
	kperc	= ((kval-istart)/(iend-istart))*100

	printks2 sprintf("%0.2f to %0.2f → ⏳", istart, iend), kval
	printks2 "\033[91m\033[1m%i%%\033[0m, ", kperc
	printks2 "%0.2f\n", kval
endif

	xout kval

	endop



