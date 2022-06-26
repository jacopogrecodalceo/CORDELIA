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


	opcode oncegen, k, i
	igen xin

ilen	ftlen abs(igen)
kndx	init 0

if	igen > 0 then
	kfact = +1
elseif	igen < 0 then
	kfact = -1
endif

if	kndx==ilen then
	kndx = 0
endif

kres	tab kndx, abs(igen)

kndx	= ((kndx+kfact)+ilen)%ilen

	xout kres
	endop

	opcode oncegen2, k[], i
	igen xin

ilen	ftlen abs(igen)

kndx	init 0

kres[]	init 2

if	igen > 0 then
	kfact = +1
elseif	igen < 0 then
	kfact = -1
endif

if	kndx==ilen then
	kndx = 0
endif

kndx	= ((kndx+kfact)+ilen)%ilen
kres1	tab kndx, abs(igen)
kres2	tab (kndx+1)%ilen, abs(igen)

kres	fillarray kres1, kres2

	xout kres
	endop


