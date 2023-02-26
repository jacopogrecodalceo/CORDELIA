	opcode	pump, k, kk[]
	kdiv, kvals[] xin

ktrig		init 1
ilen		lenarray kvals

kph			init int((chnget:i("heart") * i(kdiv) % 1) * ilen)

ktrig		changed2 kph

if ktrig == 1 then
	kout = kvals[kph]	
endif

kcycle		= chnget("heart") * kdiv
kph			= int((kcycle % 1) * ilen)

print i(kout)

	xout kout

	endop
	


