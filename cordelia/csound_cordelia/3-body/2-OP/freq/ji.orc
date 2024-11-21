
	opcode	pumps, k, kS[]
	kdiv, Svals[] xin

kdiv		init i(kdiv)
klen		lenarray Svals

kph		chnget	"heart"
kph		= ((kph * kdiv) % 1)

ionset	i kph
Sval	init Svals[int(ionset*lenarray(Svals))]
Sval	= Svals[int(kph*klen)]

kout	strtolk Sval

	xout kout
	endop

	opcode	pumpf, k, kS[]
	kdiv, Svals[] xin

kdiv		init i(kdiv)
klen		lenarray Svals

kph		chnget	"heart"
kph		= ((kph * kdiv) % 1)

ionset	i kph
Sval	init Svals[int(ionset*lenarray(Svals))]
Sval	= Svals[int(kph*klen)]

kout	ntof Sval

	xout kout
	endop

	opcode ji, k, kk
	kfreq, kji xin

kpower	= 64
while kpower > kji do
	kpower = kpower / 2
od 

kout	= kfreq * kji / kpower

	xout kout
	endop
