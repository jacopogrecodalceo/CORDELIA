	opcode	lfh, k, Jj
kdiv, ift xin

;	INIT
if	kdiv == -1 then
	kdiv = 3
elseif	kdiv == 0 then
	kdiv = 1
endif

if	ift == -1 then
	ift init giasine
endif

kphase	abs floor(kdiv)-kdiv

kndx		= ((chnget:k("heart")*kdiv)+kphase)%1

kout	table kndx, ift, 1

	xout kout
	endop

	opcode	lfh, a, Jj
kdiv, ift xin

;	INIT
if	kdiv == -1 then
	kdiv = 3
elseif	kdiv == 0 then
	kdiv = 1
endif

if	ift == -1 then
	ift init giasine
endif

kphase	abs floor(kdiv)-kdiv

andx		a chnget:k("heart")
andx		= ((andx*kdiv)+kphase)%1

aout	table andx, ift, 1

	xout aout
	endop
