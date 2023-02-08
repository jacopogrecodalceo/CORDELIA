	opcode	pump, k, kk[] ; in heart output kvals[] every kdiv
	kdiv, kvals[] xin

kdiv		init i(kdiv)
klen		lenarray kvals
ktrig		init 1
kph		init -1
ktrig		changed2 kph

if ktrig == 1 then
	kout = kvals[kph]	
endif

kph		chnget	"heart"
kph		= int(((kph * kdiv) % 1) * klen)

	xout kout

	endop
	


