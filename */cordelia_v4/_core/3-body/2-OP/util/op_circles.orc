	opcode	givemeheart, k, kk[]
	kdiv, kheart[] xin

klen	lenarray kheart

kph	chnget	"heart"
kph	=	int(kph * (klen * kdiv) % klen)

ktrig	changed	kph

if (kheart[kph] == 1 && ktrig == 1) then
	kout = 1	
else
	kout = 0
endif

	xout	kout
		endop

	opcode	givemelungs, k, kk[]
	kdiv, klungs[] xin

klen	lenarray klungs

kph	chnget	"heart"
kph	=	int(kph * (klen * kdiv) % klen)

ktrig	changed	kph

if (klungs[kph] == 1 && ktrig == 1) then
	kout = 1	
else
	kout = 0
endif

	xout	kout
		endop

	opcode	circle, k, kk[]

	kdiv, kvals[] xin

	klen	lenarray kvals

	kph	chnget	"heart"
	kph	=	int(((kph * kdiv) % 1) * klen)

	ktrig	changed	kph

	if (ktrig == 1) then
	kout = kvals[kph]	
	endif
	
	xout kout

	endop


	opcode	pumparr, k[], kk[]
	kdiv, kvals[] xin

kout[]	init 64

klen	lenarray kvals

kph	chnget	"heart"
kph	=	int(((kph * kdiv) % 1) * klen)

ktrig	changed	kph

if (ktrig == 1) then
	kout = kvals[kph]	
endif
	
	xout kout
		endop

	opcode	breathe, k, kk[]
	kdiv, kvals[] xin

	kout	init 0

	klen	lenarray kvals

	kph	chnget	"lungs"
	kph	=	int(((kph * kdiv) % 1) * klen)

	ktrig	changed	kph

	if (ktrig == 1) then
	kout = kvals[kph]	
	endif
	
	xout kout
	endop

	opcode	heartmurmur, k, kk
	kdiv, kval xin

kdyn	init 0

kph	chnget	"heart"
kph	= (kph * kdiv) % 1

kdyn	= kval - (kph * kval)
	
	xout kdyn
		endop

	opcode	suspire, k, kk
	kdiv, kval xin

kdyn	init 0

kph	chnget	"lungs"
kph	= (kph * kdiv) % 1

kdyn	= kval - (kph * kval)
	
	xout kdyn
		endop

	opcode	pumps, S, kS[]
	kdiv, Svals[] xin

	kout	init 0

	klen	lenarray Svals

	kph	chnget	"heart"
	kph	=	int(((kph * kdiv) % 1) * klen)

	ktrig	changed	kph

	if (ktrig == 1) then
	Sout = Svals[kph]	
	endif
	
	xout Sout
	endop

	opcode	breathes, S, kS[]
	kdiv, Svals[] xin

	kout	init 0

	klen	lenarray Svals

	kph	chnget	"lungs"
	kph	=	int(((kph * kdiv) % 1) * klen)

	ktrig	changed	kph

	if (ktrig == 1) then
	Sout = Svals[kph]	
	endif
	
	xout Sout
	endop


	opcode	circleconst, k, kk[]

	kdiv, kvals[] xin

	klen	lenarray kvals

	kph	chnget	"heart"
	kph	=	int(((kph * kdiv) % 1) * klen)
	
	kout = kvals[kph]

	xout kout

	endop

	opcode	circleS, S, kS[]

	kdiv, Svals[] xin

	klen	lenarray Svals

	kph	chnget	"heart"
	kph	=	int(((kph * kdiv) % 1) * klen)

	ktrig	changed	kph

	if (ktrig == 1) then
	Sout = Svals[kph]	
	endif
	
	xout Sout

	endop

