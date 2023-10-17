/*	opcode misha, k, Sik
	Sroot, iscale, kdegree xin 

iscaleroot ntom Sroot

idegrees = ftlen(iscale)

ktrig 	init 0
	
ktrig	= 1+(ktrig%2)

kndx	= kdegree % idegrees

ktab	table kndx, iscale

kres	= cpstun(ktrig, int(iscaleroot + (koct * 12) + ktab), gktuning)

	xout kres

ktrig	+= 1
	endop*/
