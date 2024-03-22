	opcode oncegen, k, i
	igen xin

ilen	ftlen abs(igen)
kndx	init 0

if	igen > 0 then
	kfact = +1
elseif	igen < 0 then
	kfact = -1
endif

if	kndx == ilen then
	kndx = 0
endif

kres	tab kndx, abs(igen)

kndx	= ((kndx+kfact)+ilen)%ilen
;printk2 kres
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


