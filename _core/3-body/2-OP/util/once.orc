	opcode once, k, k[]
	kdegrees[] xin

kndx	init 0
klen	lenarray kdegrees

if	kndx==klen then
	kndx = 0
endif

kres	= kdegrees[kndx]
kndx	+= 1

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
