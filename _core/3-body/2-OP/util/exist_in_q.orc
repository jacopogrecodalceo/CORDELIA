	opcode exist_in_q, k, i
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
kres		init istart
kstat		init itime

if changed2(gkbeatn) == 1 then
	kndx += 1
endif

if kndx >= itime then
	kres = iend
else
	kstat = itime - kndx
	printks2 "→ ⏳, \033[91m\033[1m%i\033[0m\n", kstat
	kres = istart
endif

	xout kres

	endop

