	opcode	pump, k, kk[] ; in heart output kvals[] every kdiv
	kdiv, kvals[] xin

kdiv		init i(kdiv)
klen		lenarray kvals

kph		chnget	"heart"
kph		= int(((kph * kdiv) % 1) * klen)

kout	= kvals[kph]

	xout kout

	endop
	