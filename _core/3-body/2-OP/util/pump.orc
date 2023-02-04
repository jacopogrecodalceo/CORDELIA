	opcode	pump, k, kk[] ; in heart output kvals[] every kdiv
	kdiv, kvals[] xin

kdiv	init i(kdiv)

ktrig 	init 1
kout 	init giedo12

klen	lenarray kvals

kph		chnget	"heart"
kph		= int(((kph * kdiv) % 1) * klen)

ktrig	changed2 kph

if ktrig == 1 then
	kout = kvals[kph]	
endif
	
	xout kout

	endop
	


