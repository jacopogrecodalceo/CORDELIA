	opcode once, k, kk[]
	krhythm, kdegrees[] xin

klen	lenarray kdegrees

if krhythm != 0 then
	kres	= kdegrees[((krhythm-1)%klen)]
endif

	xout kres
	endop

	opcode once, S, S[]
	String[] xin

kndx	init 0
ilen	lenarray String

if	kndx==ilen then
	kndx = 0
endif

Sout	= String[kndx]
kndx	+= 1

	xout Sout
	endop
