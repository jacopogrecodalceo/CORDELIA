	opcode accent, k, kJJ
	ieach, kdynacc, kfact xin

if	kfact==-1 then
	kfact = .65
endif

if	kdynacc==-1 then
	kdynacc = $f
endif

kdyn = kdynacc*kfact

klist[]	init ieach
klist[0]= kdynacc
kndx1	init 1

while	kndx1<ieach do
	klist[kndx1] = kdyn
	kndx1 += 1
od

kndx2	init 0
if	kndx2==ieach then
	kndx2 = 0
endif

kres	= klist[kndx2]
kndx2	+= 1


	xout kres
	endop

