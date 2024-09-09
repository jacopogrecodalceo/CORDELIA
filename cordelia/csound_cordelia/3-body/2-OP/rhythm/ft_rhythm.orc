	opcode ft_rhythm, k, kkOO
kft, kdiv, kvar, krot xin

kdir = 1
if kdiv < 0 then
	kdir = -1
endif

kdiv		abs kdiv

klocal_div divz gkdiv, kdiv, 1
kcycle		= chnget:k("heart") * klocal_div
kjit		= jitter(.5, gkbeatf/klocal_div, gkbeatf/klocal_div*2)*kvar
kph 		= .5 * (1 + kdir * (2 * ((kcycle + krot + kjit) % 1) - 1))
kres		tablekt kph, kft, 1

if changed2:k(kres) == 1 && kres > 0 then
	kout =  kres
else
	kout = 0
endif
	xout kout

	endop
