	opcode accenth, k, kJJ
	kdiv, kdyn1, kdyn2 xin

;	INIT

if	kdyn1==-1 then
	kdyn1 = $f
endif

if	kdyn2==-1 then
	kdyn2 = kdyn1*2/3
endif

karr[]	init 16
kval	= 1
until kval==(lenarray(karr)-1) do
	karr[kval] = kdyn2
	kval += 1
od

karr[0]	= kdyn1

kphase	abs floor(kdiv)-kdiv

kndx	= ((chnget:k("heart")*kdiv*gkdiv)+kphase)%1
kndx	*= kdiv

kres	= karr[int(kndx)]

	xout kres
	endop

