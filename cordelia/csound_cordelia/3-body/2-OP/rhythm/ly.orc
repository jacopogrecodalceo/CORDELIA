	opcode ly, k, k[]kO
karr[], kdiv, krot xin

ilen lenarray karr

kcycle		= chnget:k("heart") * divz(gkdiv, kdiv, 1)
kph			= int((kcycle % 1) * ilen) + krot

kout		= changed2:k(kph) == 1 ? karr[kph] : 0
kout		= kout < 0 ? samphold:k(int(random:k(0, ilen)), abs(kout)) : kout

	xout kout
	endop
