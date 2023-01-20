	opcode	eu, k, kkkSO

	konset, kpulses, kdiv, Sorgan, krot xin

kprev	init -1
keu[]	init 64
kndx	init 0

while kndx < kpulses do
	kval		=	int((konset / kpulses) * kndx)
	kndxrot		=	(kndx + krot) % kpulses
	keu[kndxrot]	=	(kval == kprev ? 0 : 1)
	kprev		=	kval
	kndx		+=	1
od

korgan	chnget	Sorgan
kph	=	(korgan * kdiv) % 1
kph	=	int(kph * kpulses)

ktrig	changed	kph

if (keu[kph] == 1 && ktrig == 1) then
	kout = 1		
else
	kout = 0
endif

	xout	kout

	endop

	opcode	eut, k, kkkO

	konset, kpulses, kdiv, krot xin

Sorgan	= "heart"

kprev	init -1
keu[]	init 64
kndx	init 0

while kndx < kpulses do
	kval		=	int((konset / kpulses) * kndx)
	kndxrot		=	(kndx + krot) % kpulses
	keu[kndxrot]	=	(kval == kprev ? 0 : 1)
	kprev		=	kval
	kndx		+=	1
od

printarray keu

korgan	chnget	Sorgan
kph	=	(korgan * kdiv) % 1
kph	=	int(kph * kpulses)

ktrig	changed	kph

if (keu[kph] == 1 && ktrig == 1) then
	kout = 1		
else
	kout = 0
endif

	xout	kout

	endop


	opcode	euc, 0, kkkSSkOOOOOO
	konset, kpulses, kdiv,
	Sorgan,
	Sinstr,
	kp3, kp4, kp5, kp6, kp7, kp8, kp9 xin

kprev	init -1
keu[]	init 64
kndx	init 0

while kndx < kpulses do
	kval	=	int((konset / kpulses) * kndx)
	keu[kndx]	=	(kval == kprev ? 0 : 1)
	kprev	=	kval
	kndx	+=	1
od

korgan	chnget	Sorgan
kph	=	(korgan * kdiv) % 1
kph	=	int(kph * kpulses)

ktrig	changed	kph


if (keu[kph] == 1 && ktrig == 1) then
	event("i", Sinstr, 0, kp3, kp4, kp5, kp6, kp7, kp8, kp9)
endif

		endop


