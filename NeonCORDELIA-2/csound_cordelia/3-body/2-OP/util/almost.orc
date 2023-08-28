	opcode almost, k, kJ
	ktempo, kfact xin

if	kfact==-1 then
	kfact = 5
endif

kres	= ktempo + randomi:k(-kfact, kfact, gkbeatf/9)

	xout kres
	endop

