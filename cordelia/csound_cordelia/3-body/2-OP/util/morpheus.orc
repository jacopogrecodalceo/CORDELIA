gimorf			ftgen 0, 0, gioscildur, 10, 1

	opcode morpheus, i, kiiooo
	kndx, ift1, ift2, ift3, ift4, ift5 xin

ifno		init giasine

iftmorf1	abs	floor(ift1)
iftmorf2	abs	floor(ift2)
iftmorf3	abs	floor(ift3)
iftmorf4	abs	floor(ift4)
iftmorf5	abs	floor(ift5)

ifact		init .995

if	ift3==0 then
	ifno	ftgenonce 0, 0, 2, -2, iftmorf1, iftmorf2
		ftmorf kndx*ifact, ifno, gimorf
elseif	ift3>0&&ift4==0 then
	ifno	ftgenonce 0, 0, 3, -2, iftmorf1, iftmorf2, iftmorf3
		ftmorf kndx*(ifact+1), ifno, gimorf
elseif	ift4>0&&ift5==0 then
	ifno	ftgenonce 0, 0, 4, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4
		ftmorf kndx*(ifact+2), ifno, gimorf
elseif	ift5>0 then
	ifno	ftgenonce 0, 0, 5, -2, iftmorf1, iftmorf2, iftmorf3, iftmorf4, iftmorf5
		ftmorf kndx*(ifact+3), ifno, gimorf
endif

	xout gimorf
	endop
